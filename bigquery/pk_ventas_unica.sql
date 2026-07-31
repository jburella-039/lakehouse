-- =============================================================================
-- PK de Ventas Unica (Venta Integral) - capa BigQuery
-- lakehouse-dev-483619 / dataset bss_comercial
--
-- Contexto (mail "PK de Ventas Unica"):
--   * En el ADW se orquesta desde DWPROD_CFG.SP_VTA_TICKETS_CAB_IDS_LOAD, que
--     puebla DWPROD_CFG.MAP_VTA_TICKETS_CAB_ID.
--   * La base es tickdia/his y la PK es la CABECERA de comprobante de facturacion:
--         id_tie_dia (TRUNC fechatrabajo) + id_suc_sucursal + id_suc_caja +
--         id_suc_nroapertura + id_tkt_tipocomprobante + id_tkt_nrocomprobante
--     filtrando es_venta = 1. Cada Fact suma luego campos segun su granularidad.
--   * id_vta_venta es un surrogate DENSO que hoy usa SOLO SSAS (no lo usa Strategy;
--     esa herramienta resuelve joins/metrias sin el). Nace como performance.
--   * Debe resistir recargas ante fallas o sucursales faltantes (idempotente) y
--     poder unir todas las FCT de Ventas.
--
-- Que hacemos en BigQuery (equivalente a ese SP, sin cambiar las fuentes):
--   1. hk_vta_venta = FARM_FINGERPRINT de la clave de cabecera (INT64 determinista).
--      Es la "hash key" (HK) analoga a HK_VTA_VENTA del ADW. Sustituye al string
--      ancho que hoy se arma en tiempo de consulta (ticket_key) por un entero:
--      COUNT(DISTINCT INT64) es mucho mas barato que COUNT(DISTINCT STRING).
--   2. Vistas vw_fct_ventas_hk / vw_fct_remitos_hk que agregan la columna hk sin
--      tocar el dato de origen (las consume Looker; ver PDT en el proyecto LookML).
--   3. map_vta_tickets_cab_id: tabla MAP a grano de cabecera (es_venta=1) con hk +
--      surrogate denso id_vta_venta, refrescada por MERGE idempotente (reload-safe).
--
-- Independencia: el PDT de Looker precomputa hk con el MISMO criterio pero lee
-- de las vistas base (vw_fct_ventas / vw_fct_remitos), asi que el LookML se
-- puede desplegar sin depender de este script. Las vistas _hk de aca son el
-- objeto de gobierno/reuso (otros consumidores: SSAS, Strategy, etc.).
-- =============================================================================


-- -----------------------------------------------------------------------------
-- 1) VENTAS: vista con hash key de cabecera (hk_vta_venta)
--    Mismo grano y misma logica de clave que el ticket_key del modelo, pero
--    materializable como INT64. NO filtra es_venta (eso lo hace la medida via
--    join a dim_tipocomprobante); la vista solo agrega la columna.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW `lakehouse-dev-483619.bss_comercial.vw_fct_ventas_hk` AS
SELECT
  f.*,
  FARM_FINGERPRINT(
    CONCAT(
      CAST(f.id_sucursal        AS STRING), '-',
      CAST(f.id_caja            AS STRING), '-',
      CAST(f.id_tipocomprobante AS STRING), '-',
      CAST(f.cd_nrocomprobante  AS STRING), '-',
      FORMAT_TIMESTAMP('%Y%m%d', f.fec_dia), '-',
      CAST(f.id_nroapertura     AS STRING)
    )
  ) AS hk_vta_venta
FROM `lakehouse-dev-483619.bss_comercial.vw_fct_ventas` AS f;


-- -----------------------------------------------------------------------------
-- 2) REMITOS: vista con hash key de remito (hk_remito)
--    Grano de remito = sucursal + dia + nro de remito (COUNTROWS SUMMARIZE DAX).
--    fec_dia en remitos es DATE -> FORMAT_DATE (no FORMAT_TIMESTAMP).
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW `lakehouse-dev-483619.bss_comercial.vw_fct_remitos_hk` AS
SELECT
  r.*,
  FARM_FINGERPRINT(
    CONCAT(
      CAST(r.id_sucursal AS STRING), '-',
      FORMAT_DATE('%Y%m%d', r.fec_dia), '-',
      CAST(r.id_nroremito AS STRING)
    )
  ) AS hk_remito
FROM `lakehouse-dev-483619.bss_comercial.vw_fct_remitos` AS r;


-- -----------------------------------------------------------------------------
-- 3) MAP de cabeceras (equivalente a DWPROD_CFG.MAP_VTA_TICKETS_CAB_ID)
--    Grano: una fila por cabecera de comprobante de VENTA (es_venta = 1).
--    Provee hk_vta_venta (join key) + id_vta_venta (surrogate denso, para SSAS).
--    Se refresca con MERGE idempotente: los hk existentes conservan su
--    id_vta_venta; los nuevos reciben MAX(id)+ROW_NUMBER. Resiste recargas y
--    sucursales faltantes (nunca reasigna ids ya emitidos).
--
--    NOTA: para Looker/dashboard NO hace falta esta tabla (alcanza con hk de la
--    vista). Se deja como equivalente fiel al SP del ADW y para consumidores que
--    necesiten el surrogate denso.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lakehouse-dev-483619.bss_comercial.map_vta_tickets_cab_id`
(
  hk_vta_venta          INT64   NOT NULL,   -- hash key de la cabecera (join key)
  id_vta_venta          INT64   NOT NULL,   -- surrogate denso (uso SSAS)
  id_tie_dia            DATE,               -- TRUNC(fechatrabajo)
  id_suc_sucursal       INT64,
  id_suc_caja           INT64,
  id_suc_nroapertura    INT64,
  id_tkt_tipocomprobante INT64,
  id_tkt_nrocomprobante INT64,
  src_fuente            STRING,
  load_ts               TIMESTAMP,
  load_batch_id         STRING
)
CLUSTER BY hk_vta_venta;

-- Refresh idempotente (correr en el job/scheduled query luego de la carga diaria).
MERGE `lakehouse-dev-483619.bss_comercial.map_vta_tickets_cab_id` AS t
USING (
  WITH cabeceras AS (
    SELECT
      FARM_FINGERPRINT(
        CONCAT(
          CAST(f.id_sucursal        AS STRING), '-',
          CAST(f.id_caja            AS STRING), '-',
          CAST(f.id_tipocomprobante AS STRING), '-',
          CAST(f.cd_nrocomprobante  AS STRING), '-',
          FORMAT_TIMESTAMP('%Y%m%d', f.fec_dia), '-',
          CAST(f.id_nroapertura     AS STRING)
        )
      )                                 AS hk_vta_venta,
      DATE(f.fec_dia)                   AS id_tie_dia,
      f.id_sucursal                     AS id_suc_sucursal,
      f.id_caja                         AS id_suc_caja,
      f.id_nroapertura                  AS id_suc_nroapertura,
      f.id_tipocomprobante              AS id_tkt_tipocomprobante,
      f.cd_nrocomprobante               AS id_tkt_nrocomprobante
    FROM `lakehouse-dev-483619.bss_comercial.vw_fct_ventas` AS f
    JOIN `lakehouse-dev-483619.bss_comercial.dim_tipocomprobante` AS tc
      ON tc.id_tipocomprobante = f.id_tipocomprobante
     AND tc.flg_esventa                -- solo comprobantes de venta (mail); flg_* son BOOL
    GROUP BY 1,2,3,4,5,6,7             -- una fila por cabecera
  ),
  nuevas AS (
    SELECT
      c.*,
      ROW_NUMBER() OVER (ORDER BY c.hk_vta_venta) AS rn
    FROM cabeceras c
    LEFT JOIN `lakehouse-dev-483619.bss_comercial.map_vta_tickets_cab_id` m
      ON m.hk_vta_venta = c.hk_vta_venta
    WHERE m.hk_vta_venta IS NULL        -- solo cabeceras aun no mapeadas
  ),
  base AS (
    SELECT COALESCE(MAX(id_vta_venta), 0) AS max_id
    FROM `lakehouse-dev-483619.bss_comercial.map_vta_tickets_cab_id`
  )
  SELECT
    n.hk_vta_venta,
    b.max_id + n.rn AS id_vta_venta,
    n.id_tie_dia, n.id_suc_sucursal, n.id_suc_caja, n.id_suc_nroapertura,
    n.id_tkt_tipocomprobante, n.id_tkt_nrocomprobante
  FROM nuevas n CROSS JOIN base b
) AS s
ON t.hk_vta_venta = s.hk_vta_venta
WHEN NOT MATCHED THEN
  INSERT (hk_vta_venta, id_vta_venta, id_tie_dia, id_suc_sucursal, id_suc_caja,
          id_suc_nroapertura, id_tkt_tipocomprobante, id_tkt_nrocomprobante,
          src_fuente, load_ts, load_batch_id)
  VALUES (s.hk_vta_venta, s.id_vta_venta, s.id_tie_dia, s.id_suc_sucursal, s.id_suc_caja,
          s.id_suc_nroapertura, s.id_tkt_tipocomprobante, s.id_tkt_nrocomprobante,
          'vw_fct_ventas', CURRENT_TIMESTAMP(),
          FORMAT_TIMESTAMP('%Y%m%d%H%M%S', CURRENT_TIMESTAMP()));


-- -----------------------------------------------------------------------------
-- 4) Validacion rapida (correr a mano tras crear los objetos)
--    Debe dar 0: el hk no colisiona vs la clave de cabecera vieja (string).
-- -----------------------------------------------------------------------------
-- SELECT
--   COUNT(DISTINCT hk_vta_venta) AS tickets_hk,
--   COUNT(DISTINCT CONCAT(CAST(id_sucursal AS STRING),'-',CAST(id_caja AS STRING),'-',
--                         CAST(id_tipocomprobante AS STRING),'-',CAST(cd_nrocomprobante AS STRING),'-',
--                         FORMAT_TIMESTAMP('%Y%m%d', fec_dia),'-',CAST(id_nroapertura AS STRING))) AS tickets_str
-- FROM `lakehouse-dev-483619.bss_comercial.vw_fct_ventas_hk`;
