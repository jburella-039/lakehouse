# =============================================================================
# TRD view: dim_formato  (capa semantica). Extiende raw_dim_formato.
# "Formato Bis": nombres del reporte (Farmacity, Get The Look, ...).
# =============================================================================

include: "/views_raw/raw_dim_formato.view.lkml"

view: dim_formato {
  extends: [raw_dim_formato]
  label: "Sucursales - Formato"

  dimension: formato_origen { hidden: no }
  dimension: formato        { hidden: no }
}
