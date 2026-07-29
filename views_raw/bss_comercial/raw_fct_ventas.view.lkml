# =============================================================================
# RAW view: raw_fct_ventas  (PDT persistido)
# Capa CRUDA (dimensiones y claves; SIN medidas). Las metricas viven en la capa
# TRD (fct_ventas).
#
# PERFORMANCE: en vez de leer la vista logica y armar el ticket_key (string
# ancho) en cada consulta, la raw se materializa como PDT (derived_table
# persistido por el datagroup diario). El PDT precomputa hk_vta_venta
# (INT64 = FARM_FINGERPRINT de la clave de cabecera, equivalente a HK_VTA_VENTA
# del ADW; mismo criterio que bss_comercial.vw_fct_ventas_hk en
# bigquery/pk_ventas_unica.sql).
#   - El PDT se particiona por fec_dia y se clusteriza por las claves de cabecera
#     -> el dashboard poda particiones y agrupa mas barato.
#   - Tickets se cuentan como COUNT(DISTINCT INT64) sobre hk_vta_venta (mucho mas
#     barato que sobre el string). Requiere PDTs habilitados en la conexion.
#   - No cambia las fuentes: hk se deriva; el dato base es identico. El SELECT lee
#     de la vista base vw_fct_ventas (no depende de crear la vista _hk primero).
# =============================================================================

view: raw_fct_ventas {
  derived_table: {
    sql:
      SELECT
        f.*,
        FARM_FINGERPRINT(CONCAT(
          CAST(f.id_sucursal        AS STRING), '-',
          CAST(f.id_caja            AS STRING), '-',
          CAST(f.id_tipocomprobante AS STRING), '-',
          CAST(f.cd_nrocomprobante  AS STRING), '-',
          FORMAT_TIMESTAMP('%Y%m%d', f.fec_dia), '-',
          CAST(f.id_nroapertura     AS STRING)
        )) AS hk_vta_venta
      FROM `lakehouse-dev-483619.bss_comercial.vw_fct_ventas` AS f ;;
    datagroup_trigger: venta_integral_datagroup
    partition_keys: ["fec_dia"]
    cluster_keys: ["id_sucursal", "id_tipocomprobante", "cd_nrocomprobante"]
  }
  fields_hidden_by_default: yes

  # ---------------------------------------------------------------------------
  # CLAVES
  # ---------------------------------------------------------------------------
  dimension: pk {
    primary_key: yes
    type: string
    sql: CONCAT(${id_sucursal},'-',${id_caja},'-',${id_tipocomprobante},'-',
                ${cd_nrocomprobante},'-',${cd_sku}) ;;
  }

  # Hash key de cabecera (INT64). Clave de ticket (resta stock) precomputada en
  # BigQuery. Las medidas de Tickets hacen COUNT(DISTINCT hk_vta_venta).
  dimension: hk_vta_venta {
    type: number
    sql: ${TABLE}.hk_vta_venta ;;
  }

  # Key de ticket legacy (string). Se conserva para drill/compatibilidad; las
  # medidas ya no la usan (usan hk_vta_venta). Prioriza id_ventaunica si existe.
  dimension: ticket_key {
    type: string
    sql: COALESCE(
            CAST(${TABLE}.id_ventaunica AS STRING),
            CONCAT(${id_sucursal},'-',${id_caja},'-',${id_tipocomprobante},'-',
                   ${cd_nrocomprobante},'-',
                   FORMAT_TIMESTAMP('%Y%m%d', ${TABLE}.fec_dia),'-',
                   CAST(${TABLE}.id_nroapertura AS STRING))
         ) ;;
  }

  # ---------------------------------------------------------------------------
  # DIMENSIONES - claves de join (a wirear en el explore)
  # ---------------------------------------------------------------------------
  dimension: id_sucursal        { type: number sql: ${TABLE}.id_sucursal ;;        label: "Sucursal (ID)" }
  dimension: id_caja            { type: number sql: ${TABLE}.id_caja ;;            label: "Caja" }
  dimension: id_tipocomprobante { type: number sql: ${TABLE}.id_tipocomprobante ;; label: "Tipo Comprobante (ID)" }
  dimension: cd_nrocomprobante  { type: number sql: ${TABLE}.cd_nrocomprobante ;;  label: "Nro Comprobante" }
  dimension: id_nroapertura     { type: number sql: ${TABLE}.id_nroapertura ;; }
  dimension: cd_sku             { type: number sql: ${TABLE}.cd_sku ;;             label: "SKU (Articulo)" }
  dimension: id_obrasocial      { type: number sql: ${TABLE}.id_obrasocial ;;      label: "Obra Social (ID)" }
  dimension: id_proveedor       { type: number sql: ${TABLE}.id_proveedor ;;       label: "Proveedor (ID)" }
  dimension: id_origenventa     { type: number sql: ${TABLE}.id_origenventa ;;     label: "Origen Venta / Canal (ID)" }

  # Jerarquia de producto historica directa en la fct (alternativa al snowflake).
  dimension: id_departamento { type: number sql: ${TABLE}.id_departamento ;; label: "Departamento (ID)" }
  dimension: id_categoria    { type: number sql: ${TABLE}.id_categoria ;;    label: "Categoria (ID)" }
  dimension: id_subcategoria { type: number sql: ${TABLE}.id_subcategoria ;; label: "Subcategoria (ID)" }
  dimension: id_marca        { type: number sql: ${TABLE}.id_marca ;;        label: "Marca (ID)" }

  # ---------------------------------------------------------------------------
  # DIMENSIONES - cliente / cobertura
  # ---------------------------------------------------------------------------
  dimension: id_cliente { type: number sql: ${TABLE}.id_cliente ;; label: "Cliente (ID)" }

  dimension: cliente_identificado {
    type: yesno
    sql: ${TABLE}.id_cliente <> -1 AND ${TABLE}.id_cliente IS NOT NULL ;;
    label: "Cliente Identificado?"
  }

  dimension: tipo_cobertura {
    type: string
    sql: CASE WHEN ${TABLE}.id_obrasocial IS NULL OR ${TABLE}.id_obrasocial <= 0
              THEN 'Particular' ELSE 'Obra Social / Coseguro' END ;;
    label: "Tipo de Cobertura"
  }

  # ---------------------------------------------------------------------------
  # TIEMPO
  # ---------------------------------------------------------------------------
  dimension_group: venta {
    type: time
    timeframes: [raw, time, hour_of_day, date, day_of_week, week, month, month_name, quarter, year]
    sql: ${TABLE}.fec_venta ;;
    label: "Fecha de Venta"
  }

  # fec_dia (dia contable) - usada para join a la dim Fecha y para el ticket_key.
  dimension_group: dia {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_dia ;;
    label: "Fecha"
  }

  # Año como STRING para el filtro selector (dropdown).
  dimension: anio_sel {
    type: string
    sql: CAST(${dia_year} AS STRING) ;;
    label: "Año"
    suggestions: ["2026", "2025", "2024"]
  }

  dimension: num_hora { type: number sql: ${TABLE}.num_hora ;; label: "Hora del Dia" }
}
