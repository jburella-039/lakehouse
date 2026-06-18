# =============================================================================
# Dashboard: Venta Integral - Tickets   (PBI: "Participaciones Tickets")
# Medida principal: tickets (resta stock).
# Layout fiel a "Tickets.png": arriba nota de Canal (no reproducible), luego
# participacion por Formato (izq), Departamento (%), Top Marcas (Marca | Tickets
# Resta Stock | Tickets vs Año Ant), nota de Campana (slot pendiente) y Top
# Productos. Sin tarjetas KPI (no estan en la foto).
#
# OMITIDO (verificado en BigQuery, reproducir en ETL):
#  - Canal (id_origenventa sin tabla de nombres dim_origenventa) -> nota arriba.
#  - Campana (sin dimension de campana en BigQuery; solo descuentos promo) -> nota.
#  - Negocio (sin tabla de segmento), Marca Propia (flag EsMarcaPropia despoblado).
# =============================================================================

- dashboard: venta_tickets
  title: "Venta Integral - Tickets"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Tickets (resta stock): participacion por formato, departamento, categoria, marca y producto."

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
  # ---------------- Canal (no disponible) - arriba del dashboard ----------------
  # Barra 100% por Canal (Brick / Envio a Domicilio / Farmacity.com / Mercado Libre
  # / Pedidos Ya / Rappi / Simplicity / The Food Market...). No se puede construir:
  # id_origenventa existe en el hecho pero la tabla de nombres dim_origenventa esta
  # vacia, no hay como rotular los canales. Reproducir en ETL.
  - name: t_canal
    type: text
    title_text: "Canal (no disponible por ahora)"
    body_text: "Aqui iria el grafico de Canal (barra 100%: Brick, Envio a Domicilio, Farmacity.com, Mercado Libre, Pedidos Ya, Rappi, Simplicity, The Food Market...). No se puede construir todavia: la columna id_origenventa existe en el hecho, pero la tabla de nombres dim_origenventa esta vacia, por lo que no hay forma de rotular los canales. Requiere poblar dim_origenventa en el ETL."
    row: 0
    col: 0
    width: 24
    height: 3

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
    row: 3
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
    row: 3
    col: 6
    width: 10
    height: 9

  # ---------------- Top Marcas (Tickets + variacion interanual) ----------------
  # Solo 3 columnas: Marca | Tickets Resta Stock | Tickets vs Año Ant.
  # pivot_index colapsa el pivote de anio a columnas planas y oculta la medida
  # base pivoteada; index 1 = 2025-03, index 2 = 2026-03 (orden por dia_year asc).
  - title: "Top Marcas - Tickets (vs Año Ant)"
    name: t_marcas
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_marca.marca, fct_ventas.dia_year, fct_ventas.tickets]
    pivots: [fct_ventas.dia_year]
    # dia_date acota a 13 meses y SOBRE-ESCRIBE el always_filter "1 months" del
    # explore (este tile no escucha "fecha"); dia_month deja solo los dos marzos.
    filters:
      fct_ventas.dia_date: "2025/03/01 to 2026/04/01"
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year, fct_ventas.tickets desc]
    limit: 15
    hidden_fields: [fct_ventas.tickets]
    dynamic_fields:
    - table_calculation: tickets_rs
      label: "Tickets Resta Stock"
      expression: "pivot_index(${fct_ventas.tickets}, 2)"
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: tickets_anio_ant
      label: "Tickets vs Año Ant"
      expression: "pivot_index(${fct_ventas.tickets}, 2)/pivot_index(${fct_ventas.tickets}, 1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria }
    row: 3
    col: 16
    width: 8
    height: 18

  # ---------------- Campana (slot de Top Categorias, no disponible) ----------------
  # Aqui iria el grafico de Campana. Se quito Top Categorias de este lugar.
  - name: t_campania
    type: text
    title_text: "Campana (no disponible por ahora)"
    body_text: "Aqui iria el grafico de Campana. No se puede construir todavia: no existe una dimension de campana en BigQuery (no hay tabla dim_campania ni columna de id de campana en fct_ventas; solo hay montos de descuento promocional mto/cnt/pct_promodescuento). Requiere reproducir la dimension Campana en el ETL."
    row: 12
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
    row: 12
    col: 8
    width: 8
    height: 9

  # ---------------- Nota de visuales omitidas ----------------
  - name: t_gaps
    type: text
    title_text: "Visuales no reproducibles (pendientes de ETL)"
    body_text: "Negocio (Salud/Belleza/Alimentacion, sin tabla de segmento) y Marca Propia (flag EsMarcaPropia despoblado). Canal tiene su propia nota arriba. Verificado contra BigQuery."
    row: 21
    col: 0
    width: 16
    height: 2
