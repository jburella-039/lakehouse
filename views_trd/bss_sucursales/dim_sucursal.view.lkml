# =============================================================================
# TRD view: dim_sucursal  (capa semantica). Extiende raw_dim_sucursal.
# =============================================================================

include: "/views_raw/bss_sucursales/raw_dim_sucursal.view.lkml"

view: dim_sucursal {
  extends: [raw_dim_sucursal]
  label: "Sucursales - Sucursal"

  dimension: id_sucursal    { hidden: no }
  dimension: cd_sucursal    { hidden: no }
  dimension: sucursal       { hidden: no }
  dimension: sucursal_corta { hidden: no }
  dimension: dsc_codsucursal { hidden: no }
  dimension: es_capital     { hidden: no }
}
