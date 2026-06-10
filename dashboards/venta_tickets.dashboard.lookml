# =============================================================================
# Dashboard: Venta Integral - Tickets   (PBI: "Participaciones Tickets")
# Medida principal: tickets (resta stock).
# Layout fiel a "Tickets.png": participacion por Formato (izq), Departamento (%),
# Top Marcas (Tickets + variacion interanual), Categoria (%) y Top Productos.
# Sin tarjetas KPI (no estan en la foto).
#
# NOTA: la captura Tickets.png es de baja resolucion; la columna derecha (Top
# Marcas) se replica del patron visible en Unidades.png (medida + var. interanual).
# Confirmar si en Tickets esa columna mostraba otra cosa.
#
# OMITIDO (verificado en BigQuery, reproducir en ETL):
#  - Canal (id_origenventa sin tabla de nombres), Negocio (sin tabla de segmento),
#    Marca Propia (flag EsMarcaPropia despoblado).
# =============================================================================

- dashboard: venta_tickets
  title: "Venta Integral - Tickets"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Tickets (resta stock): participacion por formato, departamento, categoria, marca y producto."

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
    row: 0
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
    row: 0
    col: 6
    width: 10
    height: 9

  # ---------------- Top Marcas (Tickets + variacion interanual) ----------------
  - title: "Top Marcas - Tickets (vs Ano Ant)"
    name: t_marcas
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_marca.marca, fct_ventas.dia_year, fct_ventas.tickets]
    pivots: [fct_ventas.dia_year]
    filters:
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year, fct_ventas.tickets desc]
    limit: 15
    dynamic_fields:
    - table_calculation: tickets_anio_ant
      label: "Tickets Ano Ant"
      expression: "${fct_ventas.tickets}/pivot_offset(${fct_ventas.tickets},-1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 16
    width: 8
    height: 18

  # ---------------- Categoria (%) ----------------
  - title: "Top Categorias (participacion)"
    name: t_categorias
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_categoria.categoria, fct_ventas.pct_tickets_total]
    sorts: [fct_ventas.pct_tickets_total desc]
    limit: 10
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 9
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
    row: 9
    col: 8
    width: 8
    height: 9

  # ---------------- Nota de visuales omitidas ----------------
  - name: t_gaps
    type: text
    title_text: "Visuales no reproducibles (pendientes de ETL)"
    body_text: "Canal (id_origenventa sin tabla de nombres), Negocio (Salud/Belleza/Alimentacion, sin tabla de segmento) y Marca Propia (flag EsMarcaPropia despoblado). Verificado contra BigQuery."
    row: 18
    col: 0
    width: 16
    height: 2
