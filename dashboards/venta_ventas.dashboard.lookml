# =============================================================================
# Dashboard: Venta Integral - Ventas en $   (PBI: "Participaciones $")
# Medida principal: venta_neta (s/IVA antes de descuento).
# Layout fiel a "Ventas en $.png": Formato (izq) | columna central = Canal apilado 100%
# + Marca Propia + Departamento (%) | Top Marcas (Venta + Margen $) a la derecha (misma
# altura que Formato). Debajo: Top 10 Categorias y Top Productos. SIN tarjeta KPI (no
# estaba en el original). Los apilados al 100% (Canal, Marca Propia) muestran el % dentro
# de la barra (show_value_labels).
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
  - name: anio
    title: "Año"
    type: field_filter
    model: lakehouse
    explore: fct_ventas
    field: fct_ventas.dia_year
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
  - name: marca
    title: "Marca"
    type: field_filter
    model: lakehouse
    explore: fct_ventas
    field: dim_marca.marca
  - name: canal
    title: "Canal"
    type: field_filter
    model: lakehouse
    explore: fct_ventas
    field: dim_origenventa.canal
  - name: marca_propia
    title: "Marca Propia (Origen)"
    type: field_filter
    model: lakehouse
    explore: fct_ventas
    field: dim_articulo.marca_propia
  # Negocio (Alimentacion/Belleza/Salud/Alimentacion Saludable): NO se incluye porque
  # no existe como columna en BigQuery (verificado: ni en dim, ni en sector/grupo). Es
  # un agrupador DAX del PBI. Para habilitarlo el negocio debe definir el mapeo de que
  # departamentos/categorias caen en cada Negocio (en especial "Alimentacion Saludable",
  # que es un subconjunto curado, no un departamento).

  elements:
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
    show_value_labels: true
    filters:
      fct_ventas.venta_neta: ">=1920000000"
    listen: { fecha: fct_ventas.dia_date, anio: fct_ventas.dia_year, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 6
    width: 10
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
    show_value_labels: true
    listen: { fecha: fct_ventas.dia_date, anio: fct_ventas.dia_year, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 5
    col: 6
    width: 10
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
    listen: { fecha: fct_ventas.dia_date, anio: fct_ventas.dia_year, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 0
    width: 6
    height: 13

  # ---------------- Departamento (% participacion, columnas) ----------------
  - title: "Participacion por Departamento"
    name: v_depto
    model: lakehouse
    explore: fct_ventas
    type: looker_column
    fields: [dim_departamento.departamento, fct_ventas.pct_venta_total]
    sorts: [fct_ventas.pct_venta_total desc]
    listen: { fecha: fct_ventas.dia_date, anio: fct_ventas.dia_year, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 8
    col: 6
    width: 10
    height: 5

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
    listen: { fecha: fct_ventas.dia_date, anio: fct_ventas.dia_year, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 16
    width: 8
    height: 13

  # ---------------- Top 10 Categorias ----------------
  # Categoria de Articulo (lo que el PBI llamaba "Campana"). Top 10 por venta.
  - title: "Top 10 Categorias - Venta"
    name: v_categorias
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_categoria.categoria, fct_ventas.venta_neta]
    sorts: [fct_ventas.venta_neta desc]
    limit: 10
    listen: { fecha: fct_ventas.dia_date, anio: fct_ventas.dia_year, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 0
    width: 8
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
    listen: { fecha: fct_ventas.dia_date, anio: fct_ventas.dia_year, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 8
    width: 8
    height: 9

  # ---------------- Nota de visuales omitidas ----------------
  - name: v_gaps
    type: text
    title_text: "Visuales no reproducibles (pendientes de ETL)"
    body_text: "Pendiente: Negocio (treemap Salud/Belleza/Alimentacion), que necesita un mapeo de departamentos definido por el negocio. Verificado contra BigQuery."
    row: 22
    col: 0
    width: 16
    height: 2
