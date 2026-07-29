# =============================================================================
# RAW view: raw_fct_remitos  (PDT persistido)
# Capa CRUDA (dimensiones y claves; SIN medidas). Las metricas viven en la capa
# TRD (fct_remitos). Equivale a la tabla "Remito" del cubo SSAS.
#
# PERFORMANCE: igual que ventas, la raw se materializa como PDT (persistido por
# el datagroup diario) precomputando hk_remito (INT64 = FARM_FINGERPRINT de
# sucursal + dia + nro remito; mismo criterio que vw_fct_remitos_hk). La medida
# Remitos hace COUNT(DISTINCT hk_remito) en vez de sobre el string.
# NOTA fec_dia es DATE: pk/remito_key/hk usan FORMAT_DATE (no FORMAT_TIMESTAMP).
# =============================================================================

view: raw_fct_remitos {
  derived_table: {
    sql:
      SELECT
        r.*,
        FARM_FINGERPRINT(CONCAT(
          CAST(r.id_sucursal  AS STRING), '-',
          FORMAT_DATE('%Y%m%d', r.fec_dia), '-',
          CAST(r.id_nroremito AS STRING)
        )) AS hk_remito
      FROM `lakehouse-dev-483619.bss_comercial.vw_fct_remitos` AS r ;;
    datagroup_trigger: venta_integral_datagroup
    partition_keys: ["fec_dia"]
    cluster_keys: ["id_sucursal", "id_tipocomprobante"]
  }
  fields_hidden_by_default: yes

  # ---------------------------------------------------------------------------
  # CLAVES
  # ---------------------------------------------------------------------------
  dimension: pk {
    primary_key: yes
    type: string
    sql: CONCAT(${id_sucursal},'-',${TABLE}.id_caja,'-',${id_tipocomprobante},'-',
                ${TABLE}.cd_nrocomprobante,'-',${cd_sku},'-',
                FORMAT_DATE('%Y%m%d', ${TABLE}.fec_dia)) ;;
  }

  # Hash key de remito (INT64) precomputado en BigQuery. La medida Remitos hace
  # COUNT(DISTINCT hk_remito).
  dimension: hk_remito {
    type: number
    sql: ${TABLE}.hk_remito ;;
  }

  # Key de remito legacy (string): sucursal + dia + nro de remito. Se conserva
  # para drill/compatibilidad; la medida ya usa hk_remito.
  dimension: remito_key {
    type: string
    sql: CONCAT(${id_sucursal},'-',
                FORMAT_DATE('%Y%m%d', ${TABLE}.fec_dia),'-',
                CAST(${TABLE}.id_nroremito AS STRING)) ;;
  }

  # ---------------------------------------------------------------------------
  # DIMENSIONES - claves de join
  # ---------------------------------------------------------------------------
  dimension: id_sucursal        { type: number sql: ${TABLE}.id_sucursal ;;        label: "Sucursal (ID)" }
  dimension: id_tipocomprobante { type: number sql: ${TABLE}.id_tipocomprobante ;; }
  dimension: cd_sku             { type: number sql: ${TABLE}.cd_sku ;;             label: "SKU (Articulo)" }
  dimension: id_obrasocial      { type: number sql: ${TABLE}.id_obrasocial ;; }

  # Jerarquia de producto historica directa en el hecho.
  dimension: id_departamento { type: number sql: ${TABLE}.id_departamento ;; }
  dimension: id_categoria    { type: number sql: ${TABLE}.id_categoria ;; }
  dimension: id_subcategoria { type: number sql: ${TABLE}.id_subcategoria ;; }
  dimension: id_marca        { type: number sql: ${TABLE}.id_marca ;; }

  # ---------------------------------------------------------------------------
  # DIMENSIONES - dispensa / cobertura
  # ---------------------------------------------------------------------------
  dimension: tipo_dispensa { type: string sql: ${TABLE}.dsc_dispensa ;;     label: "Tipo Dispensa" }
  dimension: nombre_medico { type: string sql: ${TABLE}.dsc_nombremedico ;; }

  dimension: es_psicotropico   { type: yesno sql: ${TABLE}.flg_psicotropico = 1 ;;    label: "Psicotropico?" }
  dimension: es_receta_digital { type: yesno sql: ${TABLE}.flg_esrecetadigital = 1 ;; label: "Receta Digital?" }

  # ---------------------------------------------------------------------------
  # TIEMPO
  # ---------------------------------------------------------------------------
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
}
