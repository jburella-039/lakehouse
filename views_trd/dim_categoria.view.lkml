# =============================================================================
# TRD view: dim_categoria  (capa semantica). Extiende raw_dim_categoria.
# =============================================================================

include: "/views_raw/raw_dim_categoria.view.lkml"

view: dim_categoria {
  extends: [raw_dim_categoria]
  label: "Comercial - Categoria"

  dimension: categoria { hidden: no }
}
