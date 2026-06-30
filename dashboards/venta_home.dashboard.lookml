# =============================================================================
# Dashboard: Venta Integral - Home   (PBI: "Total" / portada Venta Integral)
# Resumen ejecutivo: Ventas, Tickets, Unidades + ratios y tabla por Formato.
#
# Reconciliacion marzo 2026 (validado en BigQuery):
#  - Ventas 192.006B / Tickets 5.711.430 / Unidades 22.782.411 / Margen % 29.39%
#  - vs marzo 2025: Ventas 143.137B (+34.1%), Unidades 23.977.266 (-4.98%), etc.
#
# KPIs con % de variacion interanual DINAMICO. El numero grande es el valor del
# periodo (filtro Fecha); el % de comparacion es una MEASURE de la vista (*_yoy =
# (actual - año ant)/año ant) que se muestra via single_value comparison_type:
# change (flecha verde si sube, roja si baja). Margen % en puntos porcentuales (pp).
# CLAVE: los KPI escuchan fecha -> fct_ventas.filtro_fecha (filter templado del que
# dependen las medidas _periodo). Resto de tiles -> dim_fecha.fecha_date.
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

  elements:
  # ---------------- Barra de navegacion (botones a las demas paginas) ----------------
  - name: nav
    type: text
    body_text: "<a href='/dashboards/lakehouse::venta_home' style='display:inline-block;padding:7px 14px;margin-right:6px;border-radius:6px;font-weight:700;text-decoration:none;background:#000000;color:#ffffff;'>Home</a><a href='/dashboards/lakehouse::venta_tickets' style='display:inline-block;padding:7px 14px;margin-right:6px;border-radius:6px;font-weight:600;text-decoration:none;background:#eeeeee;color:#222222;'>Tickets</a><a href='/dashboards/lakehouse::venta_unidades' style='display:inline-block;padding:7px 14px;margin-right:6px;border-radius:6px;font-weight:600;text-decoration:none;background:#eeeeee;color:#222222;'>Unidades</a><a href='/dashboards/lakehouse::venta_ventas' style='display:inline-block;padding:7px 14px;margin-right:6px;border-radius:6px;font-weight:600;text-decoration:none;background:#eeeeee;color:#222222;'>Ventas en $</a><a href='/dashboards/lakehouse::venta_remitos' style='display:inline-block;padding:7px 14px;margin-right:6px;border-radius:6px;font-weight:600;text-decoration:none;background:#eeeeee;color:#222222;'>Remitos</a>"
    row: 0
    col: 0
    width: 24
    height: 2

  # ---------------- KPIs fila 1: Ventas / Tickets / Unidades (valor + % YoY) ----------------
  - title: "Ventas"
    name: h_kpi_ventas
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.venta_periodo, fct_ventas.venta_yoy]
    show_single_value_title: true
    single_value_title: "Ventas"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: false
    listen: { fecha: fct_ventas.filtro_fecha, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 2
    col: 0
    width: 8
    height: 5
  - title: "Tickets"
    name: h_kpi_tickets
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.tickets_periodo, fct_ventas.tickets_yoy]
    show_single_value_title: true
    single_value_title: "Tickets"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: false
    listen: { fecha: fct_ventas.filtro_fecha, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 2
    col: 8
    width: 8
    height: 5
  - title: "Unidades"
    name: h_kpi_unidades
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.unidades_periodo, fct_ventas.unidades_yoy]
    show_single_value_title: true
    single_value_title: "Unidades"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: false
    listen: { fecha: fct_ventas.filtro_fecha, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 2
    col: 16
    width: 8
    height: 5

  # ---------------- Evoluciones por dia (lineas) ----------------
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

  # ---------------- KPIs fila 2: ratios + Remitos (valor + % YoY) ----------------
  - title: "Ticket Promedio"
    name: h_kpi_tktprom
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.ticket_promedio_periodo, fct_ventas.ticket_promedio_yoy]
    show_single_value_title: true
    single_value_title: "Ticket Promedio"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: false
    listen: { fecha: fct_ventas.filtro_fecha, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 0
    width: 5
    height: 5
  - title: "Unidades por Ticket"
    name: h_kpi_uxt
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.unidades_por_ticket_periodo, fct_ventas.unidades_por_ticket_yoy]
    show_single_value_title: true
    single_value_title: "Unidades por Ticket"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: false
    listen: { fecha: fct_ventas.filtro_fecha, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 5
    width: 5
    height: 5
  - title: "Margen %"
    name: h_kpi_margenpct
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.margen_pct_periodo, fct_ventas.margen_pct_yoy]
    show_single_value_title: true
    single_value_title: "Margen %"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: false
    listen: { fecha: fct_ventas.filtro_fecha, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 10
    width: 5
    height: 5
  - title: "Margen $"
    name: h_kpi_margen
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.margen_periodo, fct_ventas.margen_yoy]
    show_single_value_title: true
    single_value_title: "Margen $"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: false
    listen: { fecha: fct_ventas.filtro_fecha, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 15
    width: 5
    height: 5
  - title: "Remitos"
    name: h_kpi_remitos
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.remitos_periodo, fct_remitos.remitos_yoy]
    show_single_value_title: true
    single_value_title: "Remitos"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: false
    listen: { fecha: fct_remitos.filtro_fecha, formato: dim_formato.formato, departamento: dim_departamento.departamento, marca: dim_marca.marca, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 20
    width: 4
    height: 5

  # ---------------- Tabla por Formato con variacion interanual ----------------
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

  # ---------------- Tabla por Tienda con variacion interanual ----------------
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
    body_text: "Bloque Retail/Farmacia por Id Canal: columna calculada en SSAS, no existe en BQ (reproducir en ETL). Los KPIs muestran % de variacion interanual dinamico (measure *_yoy, sigue el filtro Fecha). Margen %: variacion en puntos porcentuales. Las tablas Resumen comparan marzo 2026 vs 2025 (periodo fijo)."
    row: 38
    col: 0
    width: 24
    height: 2
