# =============================================================================
# Dashboard: Venta Integral - Unidades   (PBI: "Participaciones Unidades")
# Medida principal: unidades.
# Layout fiel a "Unidades.png": arriba nota de Canal (no reproducible), luego
# participacion por Formato (izq), nota de Marca Propia + Departamento (%), Top
# Marcas (Marca | Unidades 2025 | Unidades 2026), nota de Campana (slot pendiente)
# y Top Productos. Sin tarjetas KPI (no en la foto).
#
# Reconciliacion marzo 2026: Unidades 22.78M (cap 22.43M). Formato: Farmacity
# 86.8% / Simplicity 9.0% / Farmacity.com-ML 3.0% / The Food Market 0.9% /
# Get The Look 0.2% (coincide con la captura).
#
# OMITIDO (verificado en BigQuery, reproducir en ETL):
#  - Marca Propia (flag EsMarcaPropia despoblado) -> nota en el dashboard.
#  - Campana (sin dimension de campana en BigQuery; solo descuentos promo) -> nota.
#  - Canal (id_origenventa sin tabla de nombres), Negocio (sin tabla de segmento).
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
  # ---------------- Canal (no disponible) - arriba del dashboard ----------------
  # Barra 100% por Canal (Brick / Envio a Domicilio / Farmacity.com / Mercado Libre
  # / Pedidos Ya / Rappi / Simplicity / The Food Market...). No se puede construir:
  # id_origenventa existe en el hecho pero la tabla de nombres dim_origenventa esta
  # vacia, no hay como rotular los canales. Reproducir en ETL.
  - name: u_canal
    type: text
    title_text: "Canal (no disponible por ahora)"
    body_text: "Aqui iria el grafico de Canal (barra 100%: Brick, Envio a Domicilio, Farmacity.com, Mercado Libre, Pedidos Ya, Rappi, Simplicity, The Food Market...). No se puede construir todavia: la columna id_origenventa existe en el hecho, pero la tabla de nombres dim_origenventa esta vacia, por lo que no hay forma de rotular los canales. Requiere poblar dim_origenventa en el ETL."
    row: 0
    col: 0
    width: 24
    height: 3

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
    row: 3
    col: 0
    width: 6
    height: 9

  # ---------------- Marca Propia (no disponible) ----------------
  # Va encima de "Participacion por Departamento". El grafico Marca Propia / Resto
  # no se puede construir: el flag EsMarcaPropia esta despoblado en BigQuery (todo
  # false), asi que no hay como separar Marca Propia del Resto. Reproducir en ETL.
  - name: u_marcapropia
    type: text
    title_text: "Marca Propia (no disponible por ahora)"
    body_text: "Aqui iria el grafico de Marca Propia (Marca Propia vs Resto). No se puede construir todavia: el flag EsMarcaPropia esta despoblado en BigQuery (todos los articulos en false), por lo que no hay forma de separar Marca Propia del Resto. Requiere repoblar EsMarcaPropia en el ETL."
    row: 3
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
    row: 6
    col: 6
    width: 10
    height: 6

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
    # Sin columna "Unidades Ano Ant" (se quito el table calc de variacion %).
    # El pivote por anio deja Marca | Unidades 2025 | Unidades 2026.
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 3
    col: 16
    width: 8
    height: 18

  # ---------------- Campana (slot de Top Categorias, no disponible) ----------------
  # Aqui iria el grafico de Campana. Se quito Top Categorias de este lugar.
  - name: u_campania
    type: text
    title_text: "Campana (no disponible por ahora)"
    body_text: "Aqui iria el grafico de Campana. No se puede construir todavia: no existe una dimension de campana en BigQuery (no hay tabla dim_campania ni columna de id de campana en fct_ventas; solo hay montos de descuento promocional mto/cnt/pct_promodescuento). Requiere reproducir la dimension Campana en el ETL."
    row: 12
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
    row: 12
    col: 8
    width: 8
    height: 9

  # ---------------- Nota de visuales omitidas ----------------
  - name: u_gaps
    type: text
    title_text: "Visuales no reproducibles (pendientes de ETL)"
    body_text: "Negocio (Salud/Belleza/Alimentacion, sin tabla de segmento). Canal y Marca Propia tienen su propia nota arriba. Verificado contra BigQuery."
    row: 21
    col: 0
    width: 16
    height: 2
