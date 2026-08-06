# =============================================================================
# BAS view: bas_fct_ventas  (capa BASE / cruda)
# Espejo 1:1 de la fuente BigQuery `bss_comercial.vw_fct_ventas`. SIN labels, SIN
# medidas, SIN campos calculados, SIN sectores. Solo expone las columnas tal como
# vienen del origen. Toda la logica de negocio (metricas, labels, PK de analisis,
# periodos) vive en la capa ANL (anl_fct_ventas), que extiende esta vista.
#
# No lleva PDT: es lectura directa de la vista (sql_table_name). La materializacion
# (derived_table/PDT particionado + clusterizado) se hace en la capa ANL, que es la
# que consulta el tablero.
# =============================================================================

view: bas_fct_ventas {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.vw_fct_ventas` ;;

  # --- Columnas crudas (1:1 con el origen, sin label) ---
  dimension: id_venta          { type: number sql: ${TABLE}.id_venta ;; }
  dimension: id_sucursal       { type: number sql: ${TABLE}.id_sucursal ;; }
  dimension: id_caja           { type: number sql: ${TABLE}.id_caja ;; }
  dimension: id_tipocomprobante{ type: number sql: ${TABLE}.id_tipocomprobante ;; }
  dimension: cd_nrocomprobante { type: number sql: ${TABLE}.cd_nrocomprobante ;; }
  dimension: id_nroapertura    { type: number sql: ${TABLE}.id_nroapertura ;; }
  dimension: cd_sku            { type: number sql: ${TABLE}.cd_sku ;; }
  dimension: id_obrasocial     { type: number sql: ${TABLE}.id_obrasocial ;; }
  dimension: id_proveedor      { type: number sql: ${TABLE}.id_proveedor ;; }
  dimension: id_origenventa    { type: number sql: ${TABLE}.id_origenventa ;; }
  dimension: id_departamento   { type: number sql: ${TABLE}.id_departamento ;; }
  dimension: id_categoria      { type: number sql: ${TABLE}.id_categoria ;; }
  dimension: id_subcategoria   { type: number sql: ${TABLE}.id_subcategoria ;; }
  dimension: id_marca          { type: number sql: ${TABLE}.id_marca ;; }
  dimension: id_cliente        { type: number sql: ${TABLE}.id_cliente ;; }
  dimension: num_hora          { type: number sql: ${TABLE}.num_hora ;; }

  # --- Columnas de fecha crudas (TIMESTAMP del origen) ---
  dimension_group: venta {
    type: time
    timeframes: [raw, time, hour_of_day, date, day_of_week, week, month, month_name, quarter, year]
    sql: ${TABLE}.fec_venta ;;
  }
  dimension_group: dia {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_dia ;;
  }
}
