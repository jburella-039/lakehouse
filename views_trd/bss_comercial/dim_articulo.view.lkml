# =============================================================================
# TRD view: dim_articulo  (capa semantica)
# Extiende raw_dim_articulo. Descripcion de producto, Marca Propia (sector 3) y
# claves de la jerarquia snowflake.
# =============================================================================

include: "/views_raw/bss_comercial/raw_dim_articulo.view.lkml"

view: dim_articulo {
  extends: [raw_dim_articulo]
  label: "Comercial - Articulo"

  dimension: cd_sku       { hidden: no }
  dimension: descripcion  { hidden: no }
  dimension: producto     { hidden: no }
  dimension: marca_propia { hidden: no }
  dimension: es_ecommerce { hidden: no }
}
