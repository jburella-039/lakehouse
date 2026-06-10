# =============================================================================
# Dashboard: Venta Integral - Ventas en $   (PBI: "Participaciones $")
# Medida principal: venta_neta (s/IVA antes de descuento).
# Layout fiel a la captura "Ventas en $.png": participacion por Formato (izq),
# Departamento (%), Top Marcas (Venta + Margen $), Categoria (%) y Top Productos.
# Sin tarjetas KPI (no estan en la foto).
#
# Reconciliacion marzo 2026: Ventas 192.01B (cap 192.10B). Formato: Farmacity
# 90.3% / Simplicity 6.0% / Farmacity.com-ML 3.0% / Get The Look 0.4% /
# The Food Market 0.3% (coincide con la captura).
#
# OMITIDO (verificado, no reproducible con la data actual; reproducir en ETL):
#  - Canal (barra 100%): id_origenventa existe pero dim_origenventa esta vacia
#    (sin nombres Brick/Envio/MercadoLibre...).
#  - Negocio (treemap Salud/Belleza/Alimentacion): no hay tabla de segmento.
#  - Marca Propia (barra 100%): flag EsMarcaPropia despoblado (todo false).
# =============================================================================

- dashboard: venta_ventas
  title: "Venta Integral - Ventas en $"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Ventas s/IVA antes de descuento: participacion por formato, departamento, categoria, marca y producto."

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
    row: 0
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
    row: 0
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
    row: 0
    col: 18
    width: 6
    height: 18

  # ---------------- Categoria (% participacion, barras) ----------------
  - title: "Top Categorias (participacion)"
    name: v_categorias
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_categoria.categoria, fct_ventas.pct_venta_total]
    sorts: [fct_ventas.pct_venta_total desc]
    limit: 10
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 9
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
    row: 9
    col: 9
    width: 9
    height: 9

  # ---------------- Nota de visuales omitidas ----------------
  - name: v_gaps
    type: text
    title_text: "Visuales no reproducibles (pendientes de ETL)"
    body_text: "Canal (id_origenventa sin tabla de nombres), Negocio (Salud/Belleza/Alimentacion, sin tabla de segmento) y Marca Propia (flag EsMarcaPropia despoblado). Verificado contra BigQuery; requieren reproducirse en el ETL."
    row: 18
    col: 0
    width: 18
    height: 2
