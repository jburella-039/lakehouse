# =============================================================================
# TRD view: dim_fecha  (capa semantica / expuesta al usuario)
# Extiende raw_dim_fecha y expone los campos con label de area para el viewer.
# UNICA fuente de fecha de los dashboards Venta Integral.
# =============================================================================

include: "/views_raw/raw_dim_fecha.view.lkml"

view: dim_fecha {
  extends: [raw_dim_fecha]
  label: "Referencial - Fecha"

  dimension_group: fecha { hidden: no }
  dimension: anio         { hidden: no }
  dimension: anio_sel     { hidden: no }
  dimension: mes_num      { hidden: no }
  dimension: mes_nombre   { hidden: no }
  dimension: aniomes      { hidden: no }
  dimension: trimestre    { hidden: no }
  dimension: dia_semana   { hidden: no }
  dimension: es_finde       { hidden: no }
  dimension: es_dia_habil   { hidden: no }
  dimension: es_mes_actual  { hidden: no }
  dimension: es_anio_actual { hidden: no }

  set: detalle {
    fields: [fecha_date, anio, mes_nombre, trimestre, dia_semana]
  }
}
