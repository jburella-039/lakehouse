# =============================================================================
# Dashboard: Venta Integral - Ventas en $
# Replica de la pagina "Participaciones $" del Power BI. Viz nativas de Looker.
# Filtros default = marzo 2026 (periodo de las capturas de referencia).
#
# GAPS respecto al PBI (no reproducibles con la data actual de BigQuery):
#  - Canal (era columna calculada en SSAS)
#  - Negocio / treemap Salud-Belleza-Alimentacion (flags calculados en SSAS)
#  - Marca Propia (flag EsMarcaPropia sin poblar)
# =============================================================================

- dashboard: venta_ventas
  title: "Venta Integral - Ventas en $"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Ventas s/IVA antes de descuento por formato, departamento, categoria, marca y producto."

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
  # ---------------- KPIs ----------------
  - title: "Venta $"
    name: v_kpi_venta
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.venta_neta]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 0
    width: 6
    height: 3

  - title: "Margen $"
    name: v_kpi_margen
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.margen_pesos]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 6
    width: 6
    height: 3

  - title: "Margen %"
    name: v_kpi_margenpct
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.margen_pct]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 12
    width: 6
    height: 3

  - title: "Ticket Promedio"
    name: v_kpi_tktprom
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.ticket_promedio]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 18
    width: 6
    height: 3

  # ---------------- Venta por Formato (barras) ----------------
  - title: "Venta por Formato"
    name: v_formato
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_formato.formato, fct_ventas.venta_neta]
    sorts: [fct_ventas.venta_neta desc]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 3
    col: 0
    width: 8
    height: 9

  # ---------------- Departamento (columnas) ----------------
  - title: "Participacion por Departamento"
    name: v_depto
    model: lakehouse
    explore: fct_ventas
    type: looker_column
    fields: [dim_departamento.departamento, fct_ventas.venta_neta]
    sorts: [fct_ventas.venta_neta desc]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 3
    col: 8
    width: 16
    height: 9

  # ---------------- Top Marcas (tabla) ----------------
  - title: "Top Marcas - Venta y Margen"
    name: v_marcas
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_marca.marca, fct_ventas.venta_neta, fct_ventas.margen_pct]
    sorts: [fct_ventas.venta_neta desc]
    limit: 15
    series_cell_visualizations: { fct_ventas.venta_neta: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 12
    col: 16
    width: 8
    height: 11

  # ---------------- Top Categorias (barras) ----------------
  - title: "Top Categorias"
    name: v_categorias
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_categoria.categoria, fct_ventas.venta_neta]
    sorts: [fct_ventas.venta_neta desc]
    limit: 10
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 12
    col: 0
    width: 16
    height: 11

  # ---------------- Top Productos (tabla) ----------------
  - title: "Top Productos - Venta"
    name: v_productos
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_articulo.producto, fct_ventas.venta_neta, fct_ventas.unidades]
    sorts: [fct_ventas.venta_neta desc]
    limit: 20
    series_cell_visualizations: { fct_ventas.venta_neta: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 23
    col: 0
    width: 24
    height: 9
