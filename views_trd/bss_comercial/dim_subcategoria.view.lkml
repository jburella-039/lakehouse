# =============================================================================
# TRD view: dim_subcategoria  (capa semantica). Extiende raw_dim_subcategoria.
# =============================================================================

include: "/views_raw/bss_comercial/raw_dim_subcategoria.view.lkml"

view: dim_subcategoria {
  extends: [raw_dim_subcategoria]
  label: "Comercial - Subcategoria"

  dimension: subcategoria { hidden: no }
}
