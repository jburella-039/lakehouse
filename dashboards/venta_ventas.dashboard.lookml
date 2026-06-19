# =============================================================================
# Dashboard: Venta Integral - Ventas en $   (PBI: "Participaciones $")
# Medida principal: venta_neta (s/IVA antes de descuento).
# Layout fiel a la captura "Ventas en $.png": arriba tarjeta KPI + graficos de
# Canal y Marca Propia (apilados 100%), luego participacion por Formato (izq),
# Departamento (%), Top Marcas (Venta + Margen $), Top Categorias (participacion,
# lo que el PBI llamaba Campana) y Top Productos.
#
# Reconciliacion marzo 2026: Ventas 192.01B (cap 192.10B). Formato: Farmacity
# 90.3% / Simplicity 6.0% / Farmacity.com-ML 3.0% / Get The Look 0.4% /
# The Food Market 0.3% (coincide con la captura).
#
# REPRODUCIBLE: Canal (dim_origenventa), Marca Propia (sector id_sector 3) y
# Categoria -lo que el PBI llamaba Campana- (dim_categoria.categoria) -> graficos.
# OMITIDO:
#  - Negocio (treemap Salud/Belleza/Alimentacion): no hay columna; requiere mapeo
#    de departamentos definido por el negocio.
# =============================================================================

- dashboard: venta_ventas
  title: "Venta Integral - Ventas en $"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Ventas s/IVA antes de descuento: participacion por formato, departamento, categoria, marca y producto."

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
  # ---------------- KPI Ventas (YoY) ----------------
  # Tarjeta con la variacion % vs anio anterior (marzo 2026 vs 2025), igual que Home.
  - title: "Ventas (mar 26 vs 25)"
    name: v_kpi_ventas
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.venta_neta, fct_ventas.dia_year]
    pivots: [fct_ventas.dia_year]
    filters:
      fct_ventas.dia_date: "2025/03/01 to 2026/04/01"
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year]
    hidden_fields: [fct_ventas.venta_neta]
    dynamic_fields:
    - table_calculation: vkpi_ventas
      label: "Ventas"
      expression: "pivot_index(${fct_ventas.venta_neta}, 2)"
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: vkpi_ventas_ant
      label: "vs Año Ant"
      expression: "pivot_index(${fct_ventas.venta_neta}, 2)/pivot_index(${fct_ventas.venta_neta}, 1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Ventas (mar 26 vs 25)"
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
  # Barra horizontal apilada al 100% (segmentos = canales) desde dim_origenventa.
  # Filtra canales con <1% de venta (1% de ~192B ~= 1.92B) por la medida base.
  - title: "Ventas por Canal"
    name: v_canal
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_origenventa.canal, fct_ventas.venta_neta]
    pivots: [dim_origenventa.canal]
    sorts: [fct_ventas.venta_neta desc]
    stacking: percent
    filters:
      fct_ventas.venta_neta: ">=1920000000"
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 0
    col: 6
    width: 18
    height: 5

  # ---------------- Marca Propia vs Resto ----------------
  # Barra apilada al 100% (Marca Propia vs Resto) por venta. Marca Propia = sector
  # "Marca Propia" (id_sector 3 en dim_articulo); venta mar-2026 ~8.2%.
  - title: "Marca Propia vs Resto (venta)"
    name: v_marcapropia
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_articulo.marca_propia, fct_ventas.venta_neta]
    pivots: [dim_articulo.marca_propia]
    sorts: [fct_ventas.venta_neta desc]
    stacking: percent
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 5
    col: 0
    width: 24
    height: 3

  # ---------------- Formato (participacion, columna izquierda) ----------------
  - title: "Ventas por Formato"
    name: v_formato
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_formato.formato, fct_ventas.venta_neta, fct_ventas.pct_venta_total]
    sorts: [fct_ventas.venta_neta desc]
    series_cell_visualizations: { fct_ventas.venta_neta: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 8
    col: 0
    width: 6
    height: 9

  # ---------------- Departamento (% participacion, columnas) ----------------
  - title: "Participacion por Departamento"
    name: v_depto
    model: lakehouse
    explore: fct_ventas
    type: looker_column
    fields: [dim_departamento.departamento, fct_ventas.pct_venta_total]
    sorts: [fct_ventas.pct_venta_total desc]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 8
    col: 6
    width: 12
    height: 9

  # ---------------- Top Marcas (Venta + Margen $, columna derecha) ----------------
  - title: "Top Marcas - Venta y Margen $"
    name: v_marcas
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_marca.marca, fct_ventas.venta_neta, fct_ventas.margen_pesos]
    sorts: [fct_ventas.venta_neta desc]
    limit: 15
    series_cell_visualizations: { fct_ventas.venta_neta: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 8
    col: 18
    width: 6
    height: 18

  # ---------------- Top Categorias (participacion) ----------------
  # El visual que el PBI llamaba "Campana" es en realidad Categoria de Articulo.
  # Mismo patron que el grafico de Departamento: categoria + percent_of_total.
  - title: "Top Categorias (participacion)"
    name: v_categorias
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_categoria.categoria, fct_ventas.pct_venta_total]
    sorts: [fct_ventas.pct_venta_total desc]
    limit: 10
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 17
    col: 0
    width: 9
    height: 9

  # ---------------- Top Productos ----------------
  - title: "Top Productos - Venta"
    name: v_productos
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_articulo.producto, fct_ventas.venta_neta]
    sorts: [fct_ventas.venta_neta desc]
    limit: 20
    series_cell_visualizations: { fct_ventas.venta_neta: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 17
    col: 9
    width: 9
    height: 9

  # ---------------- Nota de visuales omitidas ----------------
  - name: v_gaps
    type: text
    title_text: "Visuales no reproducibles (pendientes de ETL)"
    body_text: "Negocio (treemap Salud/Belleza/Alimentacion): no hay columna en BigQuery; requiere mapeo de departamentos definido por el negocio. Canal, Marca Propia y Categoria (lo que el PBI llamaba Campana) ya son graficos. Verificado contra BigQuery."
    row: 26
    col: 0
    width: 18
    height: 2
