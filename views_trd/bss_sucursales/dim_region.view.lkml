# =============================================================================
# TRD view: dim_region  (capa semantica). Extiende raw_dim_region.
# =============================================================================

include: "/views_raw/bss_sucursales/raw_dim_region.view.lkml"

view: dim_region {
  extends: [raw_dim_region]
  label: "Sucursales - Region"

  dimension: region { hidden: no }
}
