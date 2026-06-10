# =============================================================================
# Dashboard: Venta Integral - Unidades   (PBI: "Participaciones Unidades")
# Medida principal: unidades.
# Layout fiel a "Unidades.png": participacion por Formato (izq), Departamento (%),
# Top Marcas (Unidades + variacion interanual), Categoria (%) y Top Productos.
# Sin tarjetas KPI (no estan en la foto).
#
# Reconciliacion marzo 2026: Unidades 22.78M (cap 22.43M). Formato: Farmacity
# 86.8% / Simplicity 9.0% / Farmacity.com-ML 3.0% / The Food Market 0.9% /
# Get The Look 0.2% (coincide con la captura).
#
# OMITIDO (verificado en BigQuery, reproducir en ETL):
#  - Canal (id_origenventa sin tabla de nombres), Negocio (sin tabla de segmento),
#    Marca Propia (flag EsMarcaPropia despoblado).
# =============================================================================

- dashboard: venta_unidades
  title: "Venta Integral - Unidades"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Unidades vendidas: participacion por formato, departamento, categoria, marca y producto."

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
  - title: "Unidades por Formato"
    name: u_formato
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_formato.formato, fct_ventas.unidades, fct_ventas.pct_unidades_total]
    sorts: [fct_ventas.unidades desc]
    series_cell_visualizations: { fct_ventas.unidades: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 0
    width: 6
    height: 9

  # ---------------- Departamento (%) ----------------
  - title: "Participacion por Departamento"
    name: u_depto
    model: lakehouse
    explore: fct_ventas
    type: looker_column
    fields: [dim_departamento.departamento, fct_ventas.pct_unidades_total]
    sorts: [fct_ventas.pct_unidades_total desc]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 6
    width: 10
    height: 9

  # ---------------- Top Marcas (Unidades + variacion interanual) ----------------
  - title: "Top Marcas - Unidades (vs Ano Ant)"
    name: u_marcas
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_marca.marca, fct_ventas.dia_year, fct_ventas.unidades]
    pivots: [fct_ventas.dia_year]
    # dia_date acota a 13 meses y SOBRE-ESCRIBE el always_filter "1 months" del
    # explore (este tile no escucha "fecha"); dia_month deja solo los dos marzos.
    filters:
      fct_ventas.dia_date: "2025/03/01 to 2026/04/01"
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year, fct_ventas.unidades desc]
    limit: 15
    dynamic_fields:
    - table_calculation: unidades_anio_ant
      label: "Unidades Ano Ant"
      expression: "${fct_ventas.unidades}/pivot_offset(${fct_ventas.unidades},-1)-1"
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
    name: u_categorias
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_categoria.categoria, fct_ventas.pct_unidades_total]
    sorts: [fct_ventas.pct_unidades_total desc]
    limit: 10
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 9
    col: 0
    width: 8
    height: 9

  # ---------------- Top Productos ----------------
  - title: "Top Productos - Unidades"
    name: u_productos
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_articulo.producto, fct_ventas.unidades]
    sorts: [fct_ventas.unidades desc]
    limit: 20
    series_cell_visualizations: { fct_ventas.unidades: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 9
    col: 8
    width: 8
    height: 9

  # ---------------- Nota de visuales omitidas ----------------
  - name: u_gaps
    type: text
    title_text: "Visuales no reproducibles (pendientes de ETL)"
    body_text: "Canal (id_origenventa sin tabla de nombres), Negocio (Salud/Belleza/Alimentacion, sin tabla de segmento) y Marca Propia (flag EsMarcaPropia despoblado). Verificado contra BigQuery."
    row: 18
    col: 0
    width: 16
    height: 2
