# =============================================================================
# Dashboard: Venta Integral - Tickets   (PBI: "Participaciones Tickets")
# Medida principal: tickets (resta stock).
# Layout fiel a "Tickets.png": arriba tarjeta KPI Tickets (YoY) + grafico de Canal
# (dim_origenventa), luego participacion por Formato (izq), Departamento (%), Top
# Marcas (Marca | Tickets Resta Stock | Tickets vs Año Ant), nota de Campana (slot
# pendiente) y Top Productos.
#
# Canal: REPRODUCIBLE desde bss_comercial.dim_origenventa (join por id_origenventa).
# OMITIDO (verificado en BigQuery, reproducir en ETL):
#  - Campana (sin dimension de campana en BigQuery; solo descuentos promo) -> nota.
#  - Negocio (sin tabla de segmento), Marca Propia (flag EsMarcaPropia despoblado).
# =============================================================================

- dashboard: venta_tickets
  title: "Venta Integral - Tickets"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Tickets (resta stock): participacion por formato, departamento, categoria, marca y producto."

  filters:
  - name: fecha
    title: "Fecha"
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
  - name: departamento
    title: "Departamento"
    type: field_filter
    model: lakehouse
    explore: fct_ventas
    field: dim_departamento.departamento
  - name: categoria
    title: "Categoria"
    type: field_filter
    model: lakehouse
    explore: fct_ventas
    field: dim_categoria.categoria

  elements:
  # ---------------- KPI Tickets (YoY) ----------------
  # Tarjeta con la variacion % vs anio anterior (marzo 2026 vs 2025), igual que Home.
  - title: "Tickets (mar 26 vs 25)"
    name: t_kpi_tickets
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.tickets, fct_ventas.dia_year]
    pivots: [fct_ventas.dia_year]
    filters:
      fct_ventas.dia_date: "2025/03/01 to 2026/04/01"
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year]
    hidden_fields: [fct_ventas.tickets]
    dynamic_fields:
    - table_calculation: tkpi_tickets
      label: "Tickets"
      expression: "pivot_index(${fct_ventas.tickets}, 2)"
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: tkpi_tickets_ant
      label: "vs Año Ant"
      expression: "pivot_index(${fct_ventas.tickets}, 2)/pivot_index(${fct_ventas.tickets}, 1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Tickets (mar 26 vs 25)"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: false
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 0
    width: 6
    height: 5

  # ---------------- Canal (origen de venta) ----------------
  # Tickets por Canal desde dim_origenventa (dsc_origenventa). Nombres tal cual la
  # dim (PDV, Farmacity Online, MERCADOFULL, ...); si se quiere el relabel del Power
  # BI (Brick, Farmacity.com, ...) hay que mapearlos en la vista.
  - title: "Tickets por Canal"
    name: t_canal
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_origenventa.canal, fct_ventas.tickets]
    sorts: [fct_ventas.tickets desc]
    series_cell_visualizations: { fct_ventas.tickets: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 6
    width: 18
    height: 5

  # ---------------- Formato (participacion) ----------------
  - title: "Tickets por Formato"
    name: t_formato
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_formato.formato, fct_ventas.tickets, fct_ventas.pct_tickets_total]
    sorts: [fct_ventas.tickets desc]
    series_cell_visualizations: { fct_ventas.tickets: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 5
    col: 0
    width: 6
    height: 9

  # ---------------- Departamento (%) ----------------
  - title: "Participacion por Departamento"
    name: t_depto
    model: lakehouse
    explore: fct_ventas
    type: looker_column
    fields: [dim_departamento.departamento, fct_ventas.pct_tickets_total]
    sorts: [fct_ventas.pct_tickets_total desc]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 5
    col: 6
    width: 10
    height: 9

  # ---------------- Top Marcas (Tickets + variacion interanual) ----------------
  # Solo 3 columnas: Marca | Tickets Resta Stock | Tickets vs Año Ant.
  # pivot_index colapsa el pivote de anio a columnas planas y oculta la medida
  # base pivoteada; index 1 = 2025-03, index 2 = 2026-03 (orden por dia_year asc).
  - title: "Top Marcas - Tickets (vs Año Ant)"
    name: t_marcas
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_marca.marca, fct_ventas.dia_year, fct_ventas.tickets]
    pivots: [fct_ventas.dia_year]
    # dia_date acota a 13 meses y SOBRE-ESCRIBE el always_filter "1 months" del
    # explore (este tile no escucha "fecha"); dia_month deja solo los dos marzos.
    filters:
      fct_ventas.dia_date: "2025/03/01 to 2026/04/01"
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year, fct_ventas.tickets desc]
    limit: 15
    hidden_fields: [fct_ventas.tickets]
    dynamic_fields:
    - table_calculation: tickets_rs
      label: "Tickets Resta Stock"
      expression: "pivot_index(${fct_ventas.tickets}, 2)"
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: tickets_anio_ant
      label: "Tickets vs Año Ant"
      expression: "pivot_index(${fct_ventas.tickets}, 2)/pivot_index(${fct_ventas.tickets}, 1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 5
    col: 16
    width: 8
    height: 18

  # ---------------- Campana (slot de Top Categorias, no disponible) ----------------
  # Aqui iria el grafico de Campana. Se quito Top Categorias de este lugar.
  - name: t_campania
    type: text
    title_text: "Campana (no disponible por ahora)"
    body_text: "Aqui iria el grafico de Campana. No se puede construir todavia: no existe una dimension de campana en BigQuery (no hay tabla dim_campania ni columna de id de campana en fct_ventas; solo hay montos de descuento promocional mto/cnt/pct_promodescuento). Requiere reproducir la dimension Campana en el ETL."
    row: 14
    col: 0
    width: 8
    height: 9

  # ---------------- Top Productos ----------------
  - title: "Top Productos - Tickets"
    name: t_productos
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_articulo.producto, fct_ventas.tickets]
    sorts: [fct_ventas.tickets desc]
    limit: 20
    series_cell_visualizations: { fct_ventas.tickets: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 14
    col: 8
    width: 8
    height: 9

  # ---------------- Nota de visuales omitidas ----------------
  - name: t_gaps
    type: text
    title_text: "Visuales no reproducibles (pendientes de ETL)"
    body_text: "Negocio (Salud/Belleza/Alimentacion, sin tabla de segmento) y Marca Propia (flag EsMarcaPropia despoblado). Canal ya es un grafico arriba (dim_origenventa). Verificado contra BigQuery."
    row: 23
    col: 0
    width: 16
    height: 2
