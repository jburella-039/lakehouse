# =============================================================================
# TRD view: dim_origenventa  (capa semantica). Extiende raw_dim_origenventa.
# Canal de venta y presencialidad.
# =============================================================================

include: "/views_raw/bss_comercial/raw_dim_origenventa.view.lkml"

view: dim_origenventa {
  extends: [raw_dim_origenventa]
  label: "Comercial - Origen de Venta"

  dimension: canal          { hidden: no }
  dimension: es_presencial  { hidden: no }
  dimension: presencialidad { hidden: no }
}
