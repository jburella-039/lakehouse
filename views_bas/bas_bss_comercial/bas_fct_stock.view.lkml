# =============================================================================
# bas_fct_stock - capa BASE de Stock (PDV)
# Nomenclatura segun Analisis_Tablas_Stock_PDV.xlsx (hoja Mapeo BT_STK_STOCK,
# columna D "fct_stock"). Validado contra el esquema real de vw_fct_stock
# (INFORMATION_SCHEMA, 2026-08-13): la vista YA expone los nombres nuevos, asi
# que identificador y columna fisica coinciden 1:1.
# NOTA: la columna real es flg_perteneceasurtid (sin la 'o' final, truncada en
# la vista) y fec_aniomes (no fec_mes). Se respetan los nombres reales.
# =============================================================================
view: bas_fct_stock {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.vw_fct_stock` ;;
  fields_hidden_by_default: yes

  dimension_group: fec_dia {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_dia ;;
  }
  dimension: id_sucursal {
    type: number
    sql: ${TABLE}.id_sucursal ;;
  }
  dimension: cd_sku {
    type: number
    sql: ${TABLE}.cd_sku ;;
  }
  dimension: id_departamento {
    type: number
    sql: ${TABLE}.id_departamento ;;
  }
  dimension: id_categoria {
    type: number
    sql: ${TABLE}.id_categoria ;;
  }
  dimension: id_subcategoria {
    type: number
    sql: ${TABLE}.id_subcategoria ;;
  }
  dimension: id_proveedor {
    type: number
    sql: ${TABLE}.id_proveedor ;;
  }
  dimension: id_marca {
    type: number
    sql: ${TABLE}.id_marca ;;
  }
  dimension_group: fec_alta {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_alta ;;
  }
  dimension_group: fec_ultimamodificacion {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_ultimamodificacion ;;
  }
  dimension: id_cargadatos {
    type: number
    sql: ${TABLE}.id_cargadatos ;;
  }
  dimension: cnt_disponible {
    type: number
    sql: ${TABLE}.cnt_disponible ;;
  }
  dimension: cnt_asignada {
    type: number
    sql: ${TABLE}.cnt_asignada ;;
  }
  dimension: cnt_devolucion {
    type: number
    sql: ${TABLE}.cnt_devolucion ;;
  }
  dimension: mto_costo {
    type: number
    sql: ${TABLE}.mto_costo ;;
  }
  dimension: mto_preciopublico {
    type: number
    sql: ${TABLE}.mto_preciopublico ;;
  }
  dimension: fec_aniomes {
    type: number
    sql: ${TABLE}.fec_aniomes ;;
  }
  dimension: mto_costodevolucion {
    type: number
    sql: ${TABLE}.mto_costodevolucion ;;
  }
  dimension: id_tiporotaciondemanda {
    type: number
    sql: ${TABLE}.id_tiporotaciondemanda ;;
  }
  dimension: id_tiporotacionvolumen {
    type: number
    sql: ${TABLE}.id_tiporotacionvolumen ;;
  }
  dimension: id_tiporotacionmargen {
    type: number
    sql: ${TABLE}.id_tiporotacionmargen ;;
  }
  dimension: flg_perteneceasurtid {
    type: number
    sql: ${TABLE}.flg_perteneceasurtid ;;
  }
  measure: count {
    type: count
  }
}
