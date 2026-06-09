# =============================================================================
# Dashboard: Venta Integral - Unidades   (PBI: "Participaciones Unidades")
# Medida principal: unidades.
# Gaps: Canal, Negocio, Marca Propia (ver venta_ventas.dashboard).
# =============================================================================

- dashboard: venta_unidades
  title: "Venta Integral - Unidades"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Unidades vendidas por formato, departamento, categoria, marca y producto."

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
  - title: "Unidades"
    name: u_kpi_unidades
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.unidades]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 0
    width: 8
    height: 3
  - title: "Unidades por Ticket"
    name: u_kpi_uxt
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.unidades_por_ticket]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 8
    width: 8
    height: 3
  - title: "Venta $"
    name: u_kpi_venta
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.venta_neta]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 16
    width: 8
    height: 3

  - title: "Unidades por Formato"
    name: u_formato
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_formato.formato, fct_ventas.unidades, fct_ventas.pct_unidades_total]
    sorts: [fct_ventas.unidades desc]
    series_cell_visualizations: { fct_ventas.unidades: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 3
    col: 0
    width: 8
    height: 9
  - title: "Participacion por Departamento"
    name: u_depto
    model: lakehouse
    explore: fct_ventas
    type: looker_column
    fields: [dim_departamento.departamento, fct_ventas.unidades]
    sorts: [fct_ventas.unidades desc]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 3
    col: 8
    width: 16
    height: 9

  - title: "Top Categorias - Unidades"
    name: u_categorias
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_categoria.categoria, fct_ventas.unidades]
    sorts: [fct_ventas.unidades desc]
    limit: 10
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 12
    col: 0
    width: 16
    height: 11
  - title: "Top Marcas - Unidades"
    name: u_marcas
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_marca.marca, fct_ventas.unidades]
    sorts: [fct_ventas.unidades desc]
    limit: 15
    series_cell_visualizations: { fct_ventas.unidades: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 12
    col: 16
    width: 8
    height: 11

  - title: "Top Productos - Unidades"
    name: u_productos
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_articulo.producto, fct_ventas.unidades, fct_ventas.venta_neta]
    sorts: [fct_ventas.unidades desc]
    limit: 20
    series_cell_visualizations: { fct_ventas.unidades: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 23
    col: 0
    width: 24
    height: 9

  - name: u_gaps
    type: text
    title_text: "Pendientes (no migrados de BigQuery)"
    body_text: "Canal, Negocio (Salud/Belleza/Alimentacion) y Marca Propia eran columnas calculadas en SSAS; requieren reproducirse en el ETL para volver a graficarse aca."
    row: 32
    col: 0
    width: 24
    height: 2
