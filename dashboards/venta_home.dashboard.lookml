# =============================================================================
# Dashboard: Venta Integral - Home   (PBI: "Total" / portada Venta Integral)
# Resumen ejecutivo: Ventas, Tickets, Unidades + ratios y tabla por Formato.
#
# Reconciliacion marzo 2026 (vs HOME.png):
#  - Ventas 192.01B (cap 192.10B) / Tickets 5.71M (5.68M) / Unidades 22.78M (22.43M)
#  - Margen % 29.4% (29.75%) / Remitos ~2.45M (2.443M)
#  Variacion interanual Ventas por Formato (vs captura tabla "Año Ant"):
#  - Farmacity +35.0% (cap +35.3%), Simplicity +25.7% (+25.2%),
#    Farmacity.com/ML +36.5% (+37.1%), The Food Market +34.6% (+33.1%),
#    Get The Look -15.3% (-9.2%). La diferencia en Get The Look es el ajuste de
#    bisiesto/Madurez del cubo (SAMEPERIODLASTYEAR), no replicado.
#
# DECISIONES (acordadas con el usuario):
#  - Bloque "Retail 184B / Farmacia 7.63B": OMITIDO. El split es por Id Canal,
#    columna calculada DAX que NO existe en BigQuery (verificado: no es obra
#    social, que da 96B/96B). Reproducir Id Canal en el ETL para habilitarlo.
#  - Interanual ("Año Ant") en la tabla de Formato: table calc con pivote por anio
#    (sin precalcular en BQ). Ahora trae marzo 2024/2025/2026 para que el 2025
#    tambien muestre su "Año Ant" (2025 vs 2024). El 2024 es el anio base (Año Ant
#    en blanco). Periodo fijo (marzo); para periodos libres haria falta MMAA en BQ.
#  - KPIs con comparacion interanual (comparison_type: change): pivote por anio +
#    pivot_index (valor 2026 vs 2025), PERIODO FIJO marzo. Como consecuencia, los
#    KPIs NO siguen el filtro "Fecha" (quedan anclados a la comparacion marzo
#    26 vs 25). Para KPIs dinamicos por periodo libre + YoY hay que precalcular MMAA
#    en BigQuery. PENDIENTE validar el render del single_value con comparacion.
#  - Filtros: Departamento, Categoria, Marca (todos con DIM) + Fecha. La tabla final
#    queda prefiltrada al anio actual (2026 vs 2025) por sus propios filtros, sin un
#    filtro de Año arriba. Canal/Marca Propia/Negocio pendientes de confirmar fuente.
# =============================================================================

- dashboard: venta_home
  title: "Venta Integral - Home"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Resumen ejecutivo: Ventas, Tickets, Unidades, margen y tabla por Formato con variacion interanual."

  filters:
  - name: fecha
    title: "Fecha"
    type: field_filter
    default_value: "2026/03/01 to 2026/04/01"
    model: lakehouse
    explore: fct_ventas
    field: dim_fecha.fecha_date
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
  # no existe como columna en BigQuery (verificado: ni dim, ni sector/grupo). Es un
  # agrupador DAX del PBI; requiere que el negocio defina el mapeo departamento/categoria
  # -> Negocio (en especial "Alimentacion Saludable", subconjunto curado).
  # NOTA: la tarjeta de Remitos (explore fct_remitos) NO tiene join a Dim Origen, por eso
  # NO escucha el filtro Canal (si lo hiciera, daria error de campo inexistente).

  elements:
  # ---------------- Barra de navegacion (botones a las demas paginas) ----------------
  - name: nav
    type: text
    body_text: "<a href='/dashboards/lakehouse::venta_home' style='display:inline-block;padding:7px 14px;margin-right:6px;border-radius:6px;font-weight:700;text-decoration:none;background:#000000;color:#ffffff;'>Home</a><a href='/dashboards/lakehouse::venta_tickets' style='display:inline-block;padding:7px 14px;margin-right:6px;border-radius:6px;font-weight:600;text-decoration:none;background:#eeeeee;color:#222222;'>Tickets</a><a href='/dashboards/lakehouse::venta_unidades' style='display:inline-block;padding:7px 14px;margin-right:6px;border-radius:6px;font-weight:600;text-decoration:none;background:#eeeeee;color:#222222;'>Unidades</a><a href='/dashboards/lakehouse::venta_ventas' style='display:inline-block;padding:7px 14px;margin-right:6px;border-radius:6px;font-weight:600;text-decoration:none;background:#eeeeee;color:#222222;'>Ventas en $</a><a href='/dashboards/lakehouse::venta_remitos' style='display:inline-block;padding:7px 14px;margin-right:6px;border-radius:6px;font-weight:600;text-decoration:none;background:#eeeeee;color:#222222;'>Remitos</a>"
    row: 0
    col: 0
    width: 24
    height: 2

  # ---------------- KPIs fila 1: Ventas / Tickets / Unidades (con YoY) ----------------
  # Cada KPI muestra el valor de marzo 2026 y la comparacion % vs marzo 2025
  # (comparison_type: change). Pivote por anio + pivot_index para tener valor actual
  # (index 2 = 2026) y anio anterior (index 1 = 2025). Periodo FIJO marzo (no escucha
  # "fecha"); para hacerlo dinamico por periodo libre hay que precalcular MMAA en BQ.
  - title: "Ventas"
    name: h_kpi_ventas
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.venta_neta]
    hidden_fields: [fct_ventas.venta_neta]
    dynamic_fields:
    - table_calculation: kpi_ventas
      label: "Ventas"
      expression: "${fct_ventas.venta_neta}"
      value_format: '$#,##0.0,,,"B"'
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Ventas"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 2
    col: 0
    width: 8
    height: 5
  - title: "Tickets"
    name: h_kpi_tickets
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.tickets]
    hidden_fields: [fct_ventas.tickets]
    dynamic_fields:
    - table_calculation: kpi_tickets
      label: "Tickets"
      expression: "${fct_ventas.tickets}"
      value_format: '#,##0.0,,"M"'
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Tickets"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 2
    col: 8
    width: 8
    height: 5
  - title: "Unidades"
    name: h_kpi_unidades
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.unidades]
    hidden_fields: [fct_ventas.unidades]
    dynamic_fields:
    - table_calculation: kpi_unidades
      label: "Unidades"
      expression: "${fct_ventas.unidades}"
      value_format: '#,##0.0,,"M"'
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Unidades"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 2
    col: 16
    width: 8
    height: 5

  # ---------------- KPIs fila 2: ratios + Remitos (con YoY) ----------------
  - title: "Ticket Promedio"
    name: h_kpi_tktprom
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.ticket_promedio]
    hidden_fields: [fct_ventas.ticket_promedio]
    dynamic_fields:
    - table_calculation: kpi_tktprom
      label: "Ticket Promedio"
      expression: "${fct_ventas.ticket_promedio}"
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Ticket Promedio"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 0
    width: 5
    height: 5
  - title: "Unidades por Ticket"
    name: h_kpi_uxt
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.unidades_por_ticket]
    hidden_fields: [fct_ventas.unidades_por_ticket]
    dynamic_fields:
    - table_calculation: kpi_uxt
      label: "Unidades por Ticket"
      expression: "${fct_ventas.unidades_por_ticket}"
      value_format_name: decimal_2
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Unidades por Ticket"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 5
    width: 5
    height: 5
  - title: "Margen %"
    name: h_kpi_margenpct
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.margen_pct]
    hidden_fields: [fct_ventas.margen_pct]
    dynamic_fields:
    - table_calculation: kpi_margenpct
      label: "Margen %"
      expression: "${fct_ventas.margen_pct}"
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Margen %"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 10
    width: 5
    height: 5
  - title: "Margen $"
    name: h_kpi_margen
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.margen_pesos]
    hidden_fields: [fct_ventas.margen_pesos]
    dynamic_fields:
    - table_calculation: kpi_margen
      label: "Margen $"
      expression: "${fct_ventas.margen_pesos}"
      value_format: '$#,##0.0,,,"B"'
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Margen $"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 15
    width: 5
    height: 5
  - title: "Remitos"
    name: h_kpi_remitos
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.remitos]
    hidden_fields: [fct_remitos.remitos]
    dynamic_fields:
    - table_calculation: kpi_remitos
      label: "Remitos"
      expression: "${fct_remitos.remitos}"
      value_format: '#,##0.0,,"M"'
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Remitos"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, marca: dim_marca.marca, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 20
    width: 4
    height: 5

  # ---------------- Evoluciones por dia (lineas) ----------------
  # Replica los sparkline/area que el PBI muestra detras de cada KPI principal.
  # Evolucion diaria de Ventas, Tickets y Unidades en el periodo seleccionado
  # (default marzo 2026). Escuchan todos los filtros, incluido Fecha.
  - title: "Ventas por dia"
    name: h_trend_ventas
    model: lakehouse
    explore: fct_ventas
    type: looker_line
    fields: [dim_fecha.fecha_date, fct_ventas.venta_neta]
    sorts: [dim_fecha.fecha_date]
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 7
    col: 0
    width: 8
    height: 6
  - title: "Tickets por dia"
    name: h_trend_tickets
    model: lakehouse
    explore: fct_ventas
    type: looker_line
    fields: [dim_fecha.fecha_date, fct_ventas.tickets]
    sorts: [dim_fecha.fecha_date]
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 7
    col: 8
    width: 8
    height: 6
  - title: "Unidades por dia"
    name: h_trend_unidades
    model: lakehouse
    explore: fct_ventas
    type: looker_line
    fields: [dim_fecha.fecha_date, fct_ventas.unidades]
    sorts: [dim_fecha.fecha_date]
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 7
    col: 16
    width: 8
    height: 6

  # ---------------- Tabla por Formato con variacion interanual ----------------
  # Muestra el anio actual (2026) y su variacion % vs el anterior (2025). El tile
  # trae SIEMPRE 2025 y 2026 (meses fijos marzo) para poder calcular el YoY; con
  # pivot_index se colapsa el pivote: index 2 = 2026 (valor) y el ratio 2026/2025-1
  # = "Año Ant". Se ocultan las medidas base pivoteadas.
  # La tabla esta prefiltrada por anio actual (2026 vs 2025) directamente en sus
  # filtros (dia_month "2025-03, 2026-03"); por eso NO hay un filtro de Año arriba del
  # dashboard. Si se filtrara a un solo anio se iria el 2025 y el YoY quedaria vacio.
  - title: "Resumen por Formato (2026 vs Año Anterior)"
    name: h_formato
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_formato.formato, fct_ventas.dia_year, fct_ventas.venta_neta, fct_ventas.tickets, fct_ventas.unidades]
    pivots: [fct_ventas.dia_year]
    filters:
      fct_ventas.dia_date: "2025/03/01 to 2026/04/01"
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year, fct_ventas.venta_neta desc]
    hidden_fields: [fct_ventas.venta_neta, fct_ventas.tickets, fct_ventas.unidades]
    dynamic_fields:
    - table_calculation: ventas_cur
      label: "Ventas"
      expression: "pivot_index(${fct_ventas.venta_neta}, 2)"
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: ventas_anio_ant
      label: "Ventas Año Ant"
      expression: "pivot_index(${fct_ventas.venta_neta}, 2)/pivot_index(${fct_ventas.venta_neta}, 1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    - table_calculation: tickets_cur
      label: "Tickets"
      expression: "pivot_index(${fct_ventas.tickets}, 2)"
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: tickets_anio_ant
      label: "Tickets Año Ant"
      expression: "pivot_index(${fct_ventas.tickets}, 2)/pivot_index(${fct_ventas.tickets}, 1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    - table_calculation: unidades_cur
      label: "Unidades"
      expression: "pivot_index(${fct_ventas.unidades}, 2)"
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: unidades_anio_ant
      label: "Unidades Año Ant"
      expression: "pivot_index(${fct_ventas.unidades}, 2)/pivot_index(${fct_ventas.unidades}, 1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 18
    col: 0
    width: 24
    height: 10

  # ---------------- Tabla por Tienda (sucursal) con variacion interanual ----------------
  # Igual que la tabla por Formato pero abierta por Tienda (dim_sucursal.sucursal).
  # Mismo esquema YoY 2026 vs 2025 (pivot_index). Limitada a las 50 tiendas con mas
  # venta para mantenerla legible; quitar el limit para ver todas.
  - title: "Resumen por Tienda (2026 vs Año Anterior)"
    name: h_tienda
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_sucursal.sucursal, fct_ventas.dia_year, fct_ventas.venta_neta, fct_ventas.tickets, fct_ventas.unidades]
    pivots: [fct_ventas.dia_year]
    filters:
      fct_ventas.dia_date: "2025/03/01 to 2026/04/01"
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year, fct_ventas.venta_neta desc]
    limit: 50
    hidden_fields: [fct_ventas.venta_neta, fct_ventas.tickets, fct_ventas.unidades]
    dynamic_fields:
    - table_calculation: tnd_ventas_cur
      label: "Ventas"
      expression: "pivot_index(${fct_ventas.venta_neta}, 2)"
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: tnd_ventas_anio_ant
      label: "Ventas Año Ant"
      expression: "pivot_index(${fct_ventas.venta_neta}, 2)/pivot_index(${fct_ventas.venta_neta}, 1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    - table_calculation: tnd_tickets_cur
      label: "Tickets"
      expression: "pivot_index(${fct_ventas.tickets}, 2)"
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: tnd_tickets_anio_ant
      label: "Tickets Año Ant"
      expression: "pivot_index(${fct_ventas.tickets}, 2)/pivot_index(${fct_ventas.tickets}, 1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    - table_calculation: tnd_unidades_cur
      label: "Unidades"
      expression: "pivot_index(${fct_ventas.unidades}, 2)"
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: tnd_unidades_anio_ant
      label: "Unidades Año Ant"
      expression: "pivot_index(${fct_ventas.unidades}, 2)/pivot_index(${fct_ventas.unidades}, 1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 28
    col: 0
    width: 24
    height: 10

  # ---------------- Nota de GAPs ----------------
  - name: h_gaps
    type: text
    title_text: "Pendientes (no migrados de BigQuery)"
    body_text: "Bloque Retail/Farmacia por Id Canal: columna calculada en SSAS, no existe en BQ (reproducir en ETL). KPIs con YoY anclados a marzo (no siguen el filtro Fecha); para KPIs dinamicos por periodo libre + YoY hay que precalcular MMAA en BigQuery. Las evoluciones por dia (lineas) si siguen el filtro Fecha."
    row: 38
    col: 0
    width: 24
    height: 2
