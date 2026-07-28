# =============================================================================
# TRD view: dim_marca  (capa semantica). Extiende raw_dim_marca.
# =============================================================================

include: "/views_raw/raw_dim_marca.view.lkml"

view: dim_marca {
  extends: [raw_dim_marca]
  label: "Comercial - Marca"

  dimension: marca          { hidden: no }
  dimension: es_laboratorio { hidden: no }
}
