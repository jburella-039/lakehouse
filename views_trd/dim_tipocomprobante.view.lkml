# =============================================================================
# TRD view: dim_tipocomprobante  (capa semantica)
# Extiende raw_dim_tipocomprobante. Provee los flags ESVENTA / RESTASTOCK que
# filtran las medidas base de los hechos.
# =============================================================================

include: "/views_raw/raw_dim_tipocomprobante.view.lkml"

view: dim_tipocomprobante {
  extends: [raw_dim_tipocomprobante]
  label: "Comercial - Tipo Comprobante"

  dimension: tipo_comprobante { hidden: no }
  dimension: es_venta      { hidden: no }
  dimension: resta_stock   { hidden: no }
  dimension: es_devolucion { hidden: no }
}
