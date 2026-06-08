# =============================================================================
# Dashboard: Venta Integral - Tickets
# Replica de "Participaciones Tickets" del Power BI. Medida principal: tickets.
# Gaps: Canal, Negocio, Marca Propia (ver venta_ventas.dashboard).
# =============================================================================

- dashboard: venta_tickets
  title: "Venta Integral - Tickets"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Tickets (resta stock) por formato, departamento, categoria, marca y producto."

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
  - title: "Tickets"
    name: t_kpi_tickets
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.tickets]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 0
    width: 8
    height: 3
  - title: "Ticket Promedio"
    name: t_kpi_tktprom
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.ticket_promedio]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 8
    width: 8
    height: 3
  - title: "Unidades por Ticket"
    name: t_kpi_uxt
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.unidades_por_ticket]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 16
    width: 8
    height: 3

  - title: "Tickets por Formato"
    name: t_formato
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_formato.formato, fct_ventas.tickets]
    sorts: [fct_ventas.tickets desc]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 3
    col: 0
    width: 8
    height: 9
  - title: "Penetracion por Departamento"
    name: t_depto
    model: lakehouse
    explore: fct_ventas
    type: looker_column
    fields: [dim_departamento.departamento, fct_ventas.tickets]
    sorts: [fct_ventas.tickets desc]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 3
    col: 8
    width: 16
    height: 9

  - title: "Top Marcas - Tickets"
    name: t_marcas
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_marca.marca, fct_ventas.tickets]
    sorts: [fct_ventas.tickets desc]
    limit: 15
    series_cell_visualizations: { fct_ventas.tickets: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 12
    col: 16
    width: 8
    height: 11
  - title: "Top Categorias - Tickets"
    name: t_categorias
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_categoria.categoria, fct_ventas.tickets]
    sorts: [fct_ventas.tickets desc]
    limit: 10
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 12
    col: 0
    width: 16
    height: 11

  - title: "Top Productos - Tickets"
    name: t_productos
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_articulo.producto, fct_ventas.tickets, fct_ventas.unidades]
    sorts: [fct_ventas.tickets desc]
    limit: 20
    series_cell_visualizations: { fct_ventas.tickets: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 23
    col: 0
    width: 24
    height: 9
