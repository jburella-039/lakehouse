# =============================================================================
# Dashboard: Venta Integral - Home 2 (PRUEBA: KPIs con % YoY dinamico)
#
# COPIA de venta_home para probar la comparacion interanual en las tarjetas KPI.
# No tocar venta_home ni el resto de las paginas: esta es la pagina de pruebas.
#
# Diferencia vs venta_home: las 8 tarjetas KPI usan las medidas dinamicas por
# periodo (venta_periodo / venta_periodo_aa, etc.) y muestran el % de variacion
# vs el mismo periodo del año anterior (single_value + comparison_type: change).
#
# CLAVE DEL ARREGLO: el filtro "Fecha" del dashboard se mapea en las tarjetas KPI
# a fct_ventas.filtro_fecha (el filter templado del que dependen las medidas
# _periodo), NO a dim_fecha.fecha_date. En los intentos previos el KPI escuchaba
# dim_fecha.fecha_date, por lo que filtro_fecha nunca recibia el rango y la
# condicion {% condition filtro_fecha %} quedaba sin valor (de ahi el Query error).
# El resto de los tiles (tendencias, tablas) siguen escuchando dim_fecha.fecha_date.
#
# Como funciona la comparacion: _periodo = valor del rango Fecha elegido;
# _periodo_aa = mismo rango pero sobre fec_dia + 1 año (DATE_ADD), o sea el mismo
# periodo del año anterior. comparison_type: change muestra (actual/ant - 1) en %.
# Validado en BigQuery: marzo 2026 192.006B vs marzo 2025 143.137B = +34.1%.
# =============================================================================

- dashboard: venta_home2
  title: "Venta Integral - Home 2 (prueba YoY)"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Copia de prueba de Home con % de variacion interanual en los KPIs (sigue el filtro Fecha)."

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

  # ---------------- KPIs fila 1: Ventas / Tickets / Unidades (con % YoY dinamico) ----------------
  # value = medida _periodo (rango Fecha actual); comparacion = % vs _periodo_aa
  # (mismo periodo año anterior). El tile escucha fecha -> fct_ventas.filtro_fecha.
  - title: "Ventas"
    name: h_kpi_ventas
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.venta_periodo, fct_ventas.venta_periodo_aa]
    hidden_fields: [fct_ventas.venta_periodo, fct_ventas.venta_periodo_aa]
    dynamic_fields:
    - table_calculation: kpi_ventas
      label: "Ventas"
      expression: "${fct_ventas.venta_periodo}"
      value_format: '$#,##0.0,,,"B"'
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_ventas_aa
      label: "vs Año Ant"
      expression: "${fct_ventas.venta_periodo_aa}"
      value_format: '$#,##0.0,,,"B"'
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Ventas"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
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
    fields: [fct_ventas.tickets_periodo, fct_ventas.tickets_periodo_aa]
    hidden_fields: [fct_ventas.tickets_periodo, fct_ventas.tickets_periodo_aa]
    dynamic_fields:
    - table_calculation: kpi_tickets
      label: "Tickets"
      expression: "${fct_ventas.tickets_periodo}"
      value_format: '#,##0.0,,"M"'
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_tickets_aa
      label: "vs Año Ant"
      expression: "${fct_ventas.tickets_periodo_aa}"
      value_format: '#,##0.0,,"M"'
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Tickets"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
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
    fields: [fct_ventas.unidades_periodo, fct_ventas.unidades_periodo_aa]
    hidden_fields: [fct_ventas.unidades_periodo, fct_ventas.unidades_periodo_aa]
    dynamic_fields:
    - table_calculation: kpi_unidades
      label: "Unidades"
      expression: "${fct_ventas.unidades_periodo}"
      value_format: '#,##0.0,,"M"'
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_unidades_aa
      label: "vs Año Ant"
      expression: "${fct_ventas.unidades_periodo_aa}"
      value_format: '#,##0.0,,"M"'
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Unidades"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    listen: { fecha: fct_ventas.filtro_fecha, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 2
    col: 16
    width: 8
    height: 5

  # ---------------- Evoluciones por dia (lineas) ----------------
  # Igual que en Home: siguen el filtro Fecha por dim_fecha.fecha_date.
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

  # ---------------- KPIs fila 2: ratios + Remitos (con % YoY dinamico) ----------------
  - title: "Ticket Promedio"
    name: h_kpi_tktprom
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.ticket_promedio_periodo, fct_ventas.ticket_promedio_periodo_aa]
    hidden_fields: [fct_ventas.ticket_promedio_periodo, fct_ventas.ticket_promedio_periodo_aa]
    dynamic_fields:
    - table_calculation: kpi_tktprom
      label: "Ticket Promedio"
      expression: "${fct_ventas.ticket_promedio_periodo}"
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_tktprom_aa
      label: "vs Año Ant"
      expression: "${fct_ventas.ticket_promedio_periodo_aa}"
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Ticket Promedio"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
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
    fields: [fct_ventas.unidades_por_ticket_periodo, fct_ventas.unidades_por_ticket_periodo_aa]
    hidden_fields: [fct_ventas.unidades_por_ticket_periodo, fct_ventas.unidades_por_ticket_periodo_aa]
    dynamic_fields:
    - table_calculation: kpi_uxt
      label: "Unidades por Ticket"
      expression: "${fct_ventas.unidades_por_ticket_periodo}"
      value_format_name: decimal_2
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_uxt_aa
      label: "vs Año Ant"
      expression: "${fct_ventas.unidades_por_ticket_periodo_aa}"
      value_format_name: decimal_2
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Unidades por Ticket"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
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
    fields: [fct_ventas.margen_pct_periodo, fct_ventas.margen_pct_periodo_aa]
    hidden_fields: [fct_ventas.margen_pct_periodo, fct_ventas.margen_pct_periodo_aa]
    dynamic_fields:
    - table_calculation: kpi_margenpct
      label: "Margen %"
      expression: "${fct_ventas.margen_pct_periodo}"
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_margenpct_aa
      label: "vs Año Ant"
      expression: "${fct_ventas.margen_pct_periodo_aa}"
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Margen %"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
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
    fields: [fct_ventas.margen_periodo, fct_ventas.margen_periodo_aa]
    hidden_fields: [fct_ventas.margen_periodo, fct_ventas.margen_periodo_aa]
    dynamic_fields:
    - table_calculation: kpi_margen
      label: "Margen $"
      expression: "${fct_ventas.margen_periodo}"
      value_format: '$#,##0.0,,,"B"'
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_margen_aa
      label: "vs Año Ant"
      expression: "${fct_ventas.margen_periodo_aa}"
      value_format: '$#,##0.0,,,"B"'
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Margen $"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
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
    fields: [fct_remitos.remitos_periodo, fct_remitos.remitos_periodo_aa]
    hidden_fields: [fct_remitos.remitos_periodo, fct_remitos.remitos_periodo_aa]
    dynamic_fields:
    - table_calculation: kpi_remitos
      label: "Remitos"
      expression: "${fct_remitos.remitos_periodo}"
      value_format: '#,##0.0,,"M"'
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_remitos_aa
      label: "vs Año Ant"
      expression: "${fct_remitos.remitos_periodo_aa}"
      value_format: '#,##0.0,,"M"'
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Remitos"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    listen: { fecha: fct_remitos.filtro_fecha, formato: dim_formato.formato, departamento: dim_departamento.departamento, marca: dim_marca.marca, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 20
    width: 4
    height: 5

  # ---------------- Tabla por Formato con variacion interanual (igual que Home) ----------------
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

  # ---------------- Tabla por Tienda con variacion interanual (igual que Home) ----------------
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

  # ---------------- Nota ----------------
  - name: h_gaps
    type: text
    title_text: "Pagina de prueba (Home 2)"
    body_text: "Prueba de KPIs con % de variacion interanual dinamico: el valor es el periodo elegido en Fecha y el % compara contra el mismo periodo del año anterior (DATE_ADD +1 año). Si funciona, se lleva el mismo patron a la Home definitiva. Bloque Retail/Farmacia por Id Canal sigue pendiente (no existe en BQ)."
    row: 38
    col: 0
    width: 24
    height: 2
