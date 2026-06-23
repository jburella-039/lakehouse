# =============================================================================
# Dashboard: Venta Integral - Unidades   (PBI: "Participaciones Unidades")
# Medida principal: unidades.
# Layout fiel a "Unidades.png": Formato (izq) | columna central = Canal apilado 100% +
# Marca Propia + Departamento (%) | Top Marcas (Marca | Unidades 2025 | Unidades 2026)
# a la derecha (misma altura que Formato). Debajo: Top 10 Categorias y Top Productos.
# SIN tarjeta KPI (no estaba en el original). Los apilados al 100% (Canal, Marca Propia)
# muestran el % dentro de la barra (show_value_labels).
#
# Reconciliacion marzo 2026: Unidades 22.78M (cap 22.43M). Formato: Farmacity
# 86.8% / Simplicity 9.0% / Farmacity.com-ML 3.0% / The Food Market 0.9% /
# Get The Look 0.2% (coincide con la captura).
#
# REPRODUCIBLE: Canal (dim_origenventa), Marca Propia (sector id_sector 3) y
# Categoria -lo que el PBI llamaba Campana- (dim_categoria.categoria) -> graficos.
# OMITIDO:
#  - Negocio (Salud/Belleza/Alimentacion): no hay columna; requiere mapeo de deptos.
# =============================================================================

- dashboard: venta_unidades
  title: "Venta Integral - Unidades"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Unidades vendidas: participacion por formato, departamento, categoria, marca y producto."

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
  # ---------------- Canal (origen de venta) ----------------
  # Barra horizontal apilada al 100% (segmentos = canales) desde dim_origenventa.
  # Filtra canales con <1% de unidades (1% de ~22.78M ~= 227.000) por la medida base
  # (Looker no permite filtrar sobre un percent_of_total).
  - title: "Unidades por Canal"
    name: u_canal
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_origenventa.canal, fct_ventas.unidades]
    pivots: [dim_origenventa.canal]
    sorts: [fct_ventas.unidades desc]
    stacking: percent
    show_value_labels: true
    filters:
      fct_ventas.unidades: ">=227000"
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 6
    width: 10
    height: 5

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
    height: 13

  # ---------------- Marca Propia vs Resto ----------------
  # Marca Propia = sector "Marca Propia" (id_sector 3 en dim_articulo). Por unidades.
  - title: "Marca Propia vs Resto (unidades)"
    name: u_marcapropia
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_articulo.marca_propia, fct_ventas.unidades]
    pivots: [dim_articulo.marca_propia]
    sorts: [fct_ventas.unidades desc]
    stacking: percent
    show_value_labels: true
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 5
    col: 6
    width: 10
    height: 3

  # ---------------- Departamento (%) ----------------
  - title: "Participacion por Departamento"
    name: u_depto
    model: lakehouse
    explore: fct_ventas
    type: looker_column
    fields: [dim_departamento.departamento, fct_ventas.pct_unidades_total]
    sorts: [fct_ventas.pct_unidades_total desc]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 8
    col: 6
    width: 10
    height: 5

  # ---------------- Top Marcas (Unidades + variacion interanual) ----------------
  - title: "Top Marcas - Unidades (vs Año Ant)"
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
    # Sin columna "Unidades Año Ant" (se quito el table calc de variacion %).
    # El pivote por anio deja Marca | Unidades 2025 | Unidades 2026.
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 16
    width: 8
    height: 13

  # ---------------- Top 10 Categorias ----------------
  # Categoria de Articulo (lo que el PBI llamaba "Campana"). Top 10 por unidades.
  - title: "Top 10 Categorias - Unidades"
    name: u_categorias
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_categoria.categoria, fct_ventas.unidades]
    sorts: [fct_ventas.unidades desc]
    limit: 10
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 13
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
    row: 13
    col: 8
    width: 8
    height: 9

  # ---------------- Nota de visuales omitidas ----------------
  - name: u_gaps
    type: text
    title_text: "Visuales no reproducibles (pendientes de ETL)"
    body_text: "Pendiente: Negocio (Salud/Belleza/Alimentacion), que necesita un mapeo de departamentos definido por el negocio. Verificado contra BigQuery."
    row: 22
    col: 0
    width: 16
    height: 2
