# =============================================================================
# TRD view: dim_horas  (capa semantica)
# Extiende raw_dim_horas. NO se joinea a los hechos (grano HH:MM:SS -> m:m).
# =============================================================================

include: "/views_raw/raw_dim_horas.view.lkml"

view: dim_horas {
  extends: [raw_dim_horas]
  label: "Referencial - Horas"

  dimension: fec_idhora   { hidden: no }
  dimension: hora         { hidden: no }
  dimension: minuto       { hidden: no }
  dimension: segundo      { hidden: no }
  dimension: hora_desc    { hidden: no }
  dimension: hora_completa { hidden: no }
  dimension: tramo_horario { hidden: no }
  dimension: es_hora_pico  { hidden: no }
  dimension: hora_laboral  { hidden: no }
}
