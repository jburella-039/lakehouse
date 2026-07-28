# =============================================================================
# TRD view: dim_obrasocial  (capa semantica). Extiende raw_dim_obrasocial.
# =============================================================================

include: "/views_raw/bss_salud/raw_dim_obrasocial.view.lkml"

view: dim_obrasocial {
  extends: [raw_dim_obrasocial]
  label: "Salud - Obra Social"

  dimension: obrasocial  { hidden: no }
  dimension: es_coseguro { hidden: no }
}
