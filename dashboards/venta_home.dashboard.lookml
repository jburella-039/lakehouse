# =============================================================================
# Dashboard: Venta Integral - Home   (PBI: "Total" / portada Venta Integral)
# Resumen ejecutivo: Ventas, Tickets, Unidades + ratios y tendencias diarias.
#
# Reconciliacion marzo 2026 (vs captura HOME.png):
#  - Ventas   192.01B  (captura 192.10B  -> 0.05%)
#  - Tickets  5.711M   (captura 5.683M)
#  - Unidades 22.78M   (captura 22.43M)
#  - Margen % 29.4%    (captura 29.75%)
#  - Remitos  ~2.45M   (captura 2.443M)
#  Formato: Farmacity 173.4B (cap 173.8B), Simplicity 11.4B, Farmacity.com/ML
#  5.71B, Get The Look 0.85B, The Food Market 0.61B. Todo cuadra.
#
# NO migrado de la captura (GAPs de BigQuery, ver venta_ventas.dashboard):
#  - Variaciones interanuales "2025: X%" (medidas MMAA / SAMEPERIODLASTYEAR del cubo).
#  - Split Total = Retail (184B) + Farmacia (7.6B): requiere la columna calculada
#    Canal. OJO: esos 7.6B son el CANAL Farmacia, no los 95.5B de la pagina Remitos.
# =============================================================================

- dashboard: venta_home
  title: "Venta Integral - Home"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Resumen ejecutivo: Ventas, Tickets, Unidades, margen y tendencias diarias."

  filters:
  - name: fecha
    title: "Fecha (dia contable)"
    type: field_filter
    default_value: "2026/03/01 to 2026/04/01"
    model: lakehouse
    explore: fct_ventas
    field: fct_ventas.dia_date
    allow_multiple_values: true
    required: false
  - name: formato
    title: "Formato"
    type: field_filter
    model: lakehouse
    explore: fct_ventas
    field: dim_formato.formato

  elements:
  # ---------------- KPIs fila 1: Ventas / Tickets / Unidades ----------------
  - title: "Ventas"
    name: h_kpi_ventas
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.venta_neta]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 0
    col: 0
    width: 8
    height: 4
  - title: "Tickets"
    name: h_kpi_tickets
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.tickets]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 0
    col: 8
    width: 8
    height: 4
  - title: "Unidades"
    name: h_kpi_unidades
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.unidades]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 0
    col: 16
    width: 8
    height: 4

  # ---------------- KPIs fila 2: ratios + Remitos ----------------
  - title: "Ticket Promedio"
    name: h_kpi_tktprom
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.ticket_promedio]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 4
    col: 0
    width: 5
    height: 3
  - title: "Unidades por Ticket"
    name: h_kpi_uxt
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.unidades_por_ticket]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 4
    col: 5
    width: 5
    height: 3
  - title: "Margen %"
    name: h_kpi_margenpct
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.margen_pct]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 4
    col: 10
    width: 5
    height: 3
  - title: "Margen $"
    name: h_kpi_margen
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.margen_pesos]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 4
    col: 15
    width: 5
    height: 3
  - title: "Remitos"
    name: h_kpi_remitos
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.remitos]
    listen: { fecha: fct_remitos.dia_date, formato: dim_formato.formato }
    row: 4
    col: 20
    width: 4
    height: 3

  # ---------------- Tendencias diarias (sparklines de la portada) ----------------
  - title: "Ventas por dia"
    name: h_trend_ventas
    model: lakehouse
    explore: fct_ventas
    type: looker_area
    fields: [fct_ventas.dia_date, fct_ventas.venta_neta]
    sorts: [fct_ventas.dia_date]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 7
    col: 0
    width: 8
    height: 7
  - title: "Tickets por dia"
    name: h_trend_tickets
    model: lakehouse
    explore: fct_ventas
    type: looker_area
    fields: [fct_ventas.dia_date, fct_ventas.tickets]
    sorts: [fct_ventas.dia_date]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 7
    col: 8
    width: 8
    height: 7
  - title: "Unidades por dia"
    name: h_trend_unidades
    model: lakehouse
    explore: fct_ventas
    type: looker_area
    fields: [fct_ventas.dia_date, fct_ventas.unidades]
    sorts: [fct_ventas.dia_date]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 7
    col: 16
    width: 8
    height: 7

  # ---------------- Tabla por Formato (Ventas / Tickets / Unidades) ----------------
  - title: "Resumen por Formato"
    name: h_formato
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_formato.formato, fct_ventas.venta_neta, fct_ventas.tickets, fct_ventas.unidades]
    sorts: [fct_ventas.venta_neta desc]
    series_cell_visualizations: { fct_ventas.venta_neta: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 14
    col: 0
    width: 24
    height: 9

  # ---------------- Nota de GAPs ----------------
  - name: h_gaps
    type: text
    title_text: "Pendientes (no migrados de BigQuery)"
    body_text: "Variaciones interanuales (2025: %) y el split Total = Retail + Farmacia por Canal no estan en la data actual; las columnas Ano Anterior y el desglose por canal requieren reproducirse en el ETL."
    row: 23
    col: 0
    width: 24
    height: 2
