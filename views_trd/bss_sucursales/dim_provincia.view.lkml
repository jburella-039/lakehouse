# =============================================================================
# TRD view: dim_provincia  (capa semantica). Extiende raw_dim_provincia.
# =============================================================================

include: "/views_raw/bss_sucursales/raw_dim_provincia.view.lkml"

view: dim_provincia {
  extends: [raw_dim_provincia]
  label: "Sucursales - Provincia"

  dimension: provincia { hidden: no }
}
