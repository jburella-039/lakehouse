# =============================================================================
# Dashboard: Venta Integral - Tickets   (PBI: "Participaciones Tickets")
# Medida principal: tickets (resta stock).
# Layout fiel a "Tickets.png": Formato (izq) | columna central = Canal apilado 100% +
# Marca Propia + Departamento (%) | Top Marcas (Marca | Tickets Resta Stock | Tickets vs
# Año Ant) a la derecha (misma altura que Formato). Debajo: Top 10 Categorias, Top
# Productos, nota Negocio. SIN tarjeta KPI (no estaba en el original). Los apilados al
# 100% (Canal, Marca Propia) muestran el % dentro de la barra (show_value_labels).
#
# REPRODUCIBLE (verificado en BigQuery):
#  - Canal: bss_comercial.dim_origenventa (join por id_origenventa) -> grafico.
#  - Marca Propia: sector "Marca Propia" = id_sector 3 (dim_articulo); venta 8.2%
#    coincide con el PBI -> grafico.
#  - "Campana": el negocio confirmo que es Categoria de Articulo
#    (dim_categoria.categoria) -> grafico Top Categorias (participacion).
# OMITIDO:
#  - Negocio (Salud/Belleza/Alimentacion): no hay columna; Sector no es lo mismo.
#    Requiere mapeo de departamentos definido por el negocio -> nota.
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
  # ---------------- Formato (participacion, columna izquierda) ----------------
  # Va arriba a la izquierda cubriendo la columna, como en el original.
  - title: "Tickets por Formato"
    name: t_formato
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_formato.formato, fct_ventas.tickets, fct_ventas.pct_tickets_total]
    sorts: [fct_ventas.tickets desc]
    series_cell_visualizations: { fct_ventas.tickets: { is_active: true } }
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 0
    width: 6
    height: 13

  # ---------------- Canal (origen de venta) ----------------
  # Tickets por Canal desde dim_origenventa (dsc_origenventa). Nombres tal cual la
  # dim (PDV, Farmacity Online, MERCADOFULL, ...); si se quiere el relabel del Power
  # BI (Brick, Farmacity.com, ...) hay que mapearlos en la vista.
  # Barra horizontal apilada al 100% (una sola barra, segmentos = canales), como
  # el visual original del Power BI. Canal va como pivote y stacking: percent.
  - title: "Tickets por Canal"
    name: t_canal
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_origenventa.canal, fct_ventas.tickets]
    pivots: [dim_origenventa.canal]
    sorts: [fct_ventas.tickets desc]
    stacking: percent
    # Muestra el % dentro de cada segmento (con stacking percent los value labels
    # se renderizan como porcentaje), igual que el visual original del Power BI.
    show_value_labels: true
    # Oculta los canales con menos de ~1% de los tickets. Looker NO permite filtrar
    # sobre un percent_of_total, asi que se filtra por el conteo base (HAVING):
    # ~1% de ~5.7M tickets de marzo ~= 57.000. Ajustar el umbral si cambia el periodo.
    filters:
      fct_ventas.tickets: ">=57000"
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 6
    width: 10
    height: 5

  # ---------------- Departamento (%) ----------------
  - title: "Participacion por Departamento"
    name: t_depto
    model: lakehouse
    explore: fct_ventas
    type: looker_column
    fields: [dim_departamento.departamento, fct_ventas.pct_tickets_total]
    sorts: [fct_ventas.pct_tickets_total desc]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 8
    col: 6
    width: 10
    height: 5

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
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 16
    width: 8
    height: 13

  # ---------------- Top 10 Categorias ----------------
  # El visual que el PBI llamaba "Campana" es Categoria de Articulo (dim_categoria,
  # ahora bss_comercial -> nombres reales). Top 10 por la medida (tickets). NO se usa
  # percent_of_total: con limit Looker lo deja en null (necesita todo el set) y sin
  # limit se ven demasiadas categorias. El orden por valor = orden por participacion.
  - title: "Top 10 Categorias - Tickets"
    name: t_categorias
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_categoria.categoria, fct_ventas.tickets]
    sorts: [fct_ventas.tickets desc]
    limit: 10
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
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
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 8
    width: 8
    height: 9

  # ---------------- Marca Propia vs Resto ----------------
  # Marca Propia = sector "Marca Propia" (id_sector 3 en dim_articulo). Se muestra por
  # unidades (split limpio que suma 100%); por tickets el count_distinct duplicaria
  # los tickets que tienen items de ambos grupos.
  - title: "Marca Propia vs Resto (unidades)"
    name: t_marcapropia
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    fields: [dim_articulo.marca_propia, fct_ventas.unidades]
    pivots: [dim_articulo.marca_propia]
    sorts: [fct_ventas.unidades desc]
    stacking: percent
    show_value_labels: true
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 5
    col: 6
    width: 10
    height: 3

  # ---------------- Negocio (Salud/Belleza/Alimentacion) - pendiente de mapeo ----------------
  - name: t_negocio
    type: text
    title_text: "Negocio (Salud / Belleza / Alimentacion): pendiente de definicion"
    body_text: "No hay una columna de Negocio en BigQuery. Lo mas parecido es Sector (Farmacia, Masivos, Marca Propia, Suministros, em-commerce), que NO es Salud/Belleza/Alimentacion. Para armar este grafico hace falta que el negocio defina como se agrupan los departamentos (COSMETICA Y FRAGANCIAS, MEDICAMENTOS, ALIMENTOS Y BEBIDAS, HIGIENE Y CUIDADO PERSONAL, OTC FARMA/NO FARMA...) en Salud/Belleza/Alimentacion."
    row: 13
    col: 16
    width: 8
    height: 9

  # ---------------- Nota de visuales omitidas ----------------
  - name: t_gaps
    type: text
    title_text: "Visuales no reproducibles (pendientes de ETL)"
    body_text: "Pendiente: Negocio (Salud/Belleza/Alimentacion), que necesita un mapeo de departamentos definido por el negocio. Verificado contra BigQuery."
    row: 22
    col: 0
    width: 16
    height: 2
