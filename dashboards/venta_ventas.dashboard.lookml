# =============================================================================
# Dashboard: Venta Integral - Ventas en $   (PBI: "Participaciones $")
# Medida principal: venta_neta (s/IVA antes de descuento).
# Layout fiel a la captura "Ventas en $.png": arriba notas de Canal y Marca Propia
# (no reproducibles), luego participacion por Formato (izq), Departamento (%), Top
# Marcas (Venta + Margen $), nota de Campana (slot pendiente) y Top Productos.
# Sin tarjetas KPI (no estan en la foto).
#
# Reconciliacion marzo 2026: Ventas 192.01B (cap 192.10B). Formato: Farmacity
# 90.3% / Simplicity 6.0% / Farmacity.com-ML 3.0% / Get The Look 0.4% /
# The Food Market 0.3% (coincide con la captura).
#
# OMITIDO (verificado, no reproducible con la data actual; reproducir en ETL):
#  - Canal (barra 100%): id_origenventa existe pero dim_origenventa esta vacia
#    (sin nombres Brick/Envio/MercadoLibre...) -> nota arriba.
#  - Marca Propia (barra 100%): flag EsMarcaPropia despoblado (todo false) -> nota arriba.
#  - Campana: sin dimension de campana en BigQuery (solo descuentos promo) -> nota.
#  - Negocio (treemap Salud/Belleza/Alimentacion): no hay tabla de segmento.
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

  # ---------------- Canal (no disponible) - arriba del dashboard ----------------
  # Barra 100% por Canal (Brick / Envio a Domicilio / Farmacity.com / Mercado Libre
  # / Pedidos Ya / Rappi / Simplicity / The Food Market...). No se puede construir:
  # id_origenventa existe en el hecho pero la tabla de nombres dim_origenventa esta
  # vacia, no hay como rotular los canales. Reproducir en ETL.
  - name: v_canal
    type: text
    title_text: "Canal (no disponible por ahora)"
    body_text: "Aqui iria el grafico de Canal (barra 100%: Brick, Envio a Domicilio, Farmacity.com, Mercado Libre, Pedidos Ya, Rappi, Simplicity, The Food Market...). No se puede construir todavia: la columna id_origenventa existe en el hecho, pero la tabla de nombres dim_origenventa esta vacia, por lo que no hay forma de rotular los canales. Requiere poblar dim_origenventa en el ETL."
    row: 0
    col: 6
    width: 18
    height: 5

  # ---------------- Marca Propia (no disponible) - arriba del dashboard ----------------
  # Barra Marca Propia vs Resto. El flag EsMarcaPropia esta despoblado (todo false).
  - name: v_marcapropia
    type: text
    title_text: "Marca Propia (no disponible por ahora)"
    body_text: "Aqui iria el grafico de Marca Propia (Marca Propia vs Resto). No se puede construir todavia: el flag EsMarcaPropia esta despoblado en BigQuery (todos los articulos en false), por lo que no hay forma de separar Marca Propia del Resto. Requiere repoblar EsMarcaPropia en el ETL."
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

  # ---------------- Campana (slot de Top Categorias, no disponible) ----------------
  # Aqui iria el grafico de Campana. Se quito Top Categorias de este lugar.
  - name: v_campania
    type: text
    title_text: "Campana (no disponible por ahora)"
    body_text: "Aqui iria el grafico de Campana. No se puede construir todavia: no existe una dimension de campana en BigQuery (no hay tabla dim_campania ni columna de id de campana en fct_ventas; solo hay montos de descuento promocional mto/cnt/pct_promodescuento). Requiere reproducir la dimension Campana en el ETL."
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
    body_text: "Negocio (treemap Salud/Belleza/Alimentacion): no hay tabla de segmento en BigQuery. Canal y Marca Propia tienen su propia nota arriba. Verificado contra BigQuery; requieren reproducirse en el ETL."
    row: 26
    col: 0
    width: 18
    height: 2
