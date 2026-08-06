# =============================================================================
# Dashboard: PRUEBA PK Ventas (id_venta BQ vs hash Looker)
# Pedido de Luca: validar que la PK nativa id_venta da el mismo Tickets que la
# PK hash actual. NO productivo (borrar cuando se confirme).
# Dos graficas de Tickets por mes, una por cada PK, para comparar lado a lado;
# los valores deben coincidir mes a mes.
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
  # ---- Grafica 1: PK id_venta (nativa de BigQuery / Alex) ----
  - title: "Tickets con PK id_venta (BigQuery)"
    name: pk_test_idventa
    model: lakehouse
    explore: fct_ventas_pktest
    type: looker_column
    fields: [fct_ventas_pktest.dia_month, fct_ventas_pktest.tickets_idventa_TEST]
    sorts: [fct_ventas_pktest.dia_month]
    listen:
      fecha: fct_ventas_pktest.dia_date
    row: 0
    col: 0
    width: 12
    height: 8

  # ---- Grafica 2: PK hash (calculada hoy en Looker) ----
  - title: "Tickets con PK hash (Looker)"
    name: pk_test_hash
    model: lakehouse
    explore: fct_ventas_pktest
    type: looker_column
    fields: [fct_ventas_pktest.dia_month, fct_ventas_pktest.tickets_hash_TEST]
    sorts: [fct_ventas_pktest.dia_month]
    listen:
      fecha: fct_ventas_pktest.dia_date
    row: 0
    col: 12
    width: 12
    height: 8

  # ---- Tabla de control: las dos PKs + diferencia (debe ser 0) ----
  - title: "Control: diferencia por mes (debe ser 0)"
    name: pk_test_control
    model: lakehouse
    explore: fct_ventas_pktest
    type: looker_grid
    fields: [fct_ventas_pktest.dia_month, fct_ventas_pktest.tickets_idventa_TEST, fct_ventas_pktest.tickets_hash_TEST, fct_ventas_pktest.tickets_diff_TEST]
    sorts: [fct_ventas_pktest.dia_month desc]
    listen:
      fecha: fct_ventas_pktest.dia_date
    row: 8
    col: 0
    width: 24
    height: 8
