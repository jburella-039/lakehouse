# =============================================================================
# Dashboard: PRUEBA PK Ventas (id_venta BQ vs hash Looker)
# Pedido de Luca: validar en UN solo grafico que la PK nativa id_venta da el
# mismo Tickets que la PK hash actual. NO productivo (borrar cuando se confirme).
# Una sola tile: Tickets por mes calculado con las dos PKs + su diferencia
# (la columna Diferencia debe ser 0 en todos los meses).
# =============================================================================

- dashboard: pk_test
  title: "PRUEBA - PK Ventas (id_venta vs hash)"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Validacion de la PK nativa id_venta contra el hash calculado en Looker."

  filters:
  - name: fecha
    title: "Fecha"
    type: field_filter
    default_value: "2026"
    model: lakehouse
    explore: fct_ventas_pktest
    field: fct_ventas_pktest.dia_date
    allow_multiple_values: true
    required: false

  elements:
  - title: "Tickets: id_venta (BQ) vs hash (Looker)"
    name: pk_test_tickets
    model: lakehouse
    explore: fct_ventas_pktest
    type: looker_grid
    fields: [fct_ventas_pktest.dia_month, fct_ventas_pktest.tickets_hash_TEST, fct_ventas_pktest.tickets_idventa_TEST, fct_ventas_pktest.tickets_diff_TEST]
    sorts: [fct_ventas_pktest.dia_month desc]
    listen:
      fecha: fct_ventas_pktest.dia_date
    row: 0
    col: 0
    width: 12
    height: 8
