# =============================================================================
# Dashboard: Venta Integral (UNIFICADO con tabs)
# rev: 2026-07-02d (encabezado verde + estilo white en las 13 grillas del reporte)
#
# Combina las 5 paginas (Home, Tickets, Unidades, Ventas en $, Remitos) en un solo
# dashboard usando tabs nativos de LookML (parametro tabs + tab_name por elemento).
# Requiere layout: newspaper. Filtros globales compartidos entre tabs; cada tile
# escucha solo los que le aplican. Las tabs reemplazan la barra de navegacion.
#
# No reemplaza a los 5 dashboards individuales, que siguen existiendo.
#
# KPIs (Home y Remitos): valor del periodo (filtro Fecha) + % de variacion interanual
# via measure de la vista (*_yoy) mostrada como comparacion (comparison_type: change,
# flecha verde sube / roja baja). Margen % en puntos porcentuales (pp).
#
# Colores por metrica (tema Farmacity): Ventas = verde #2E7D32, Tickets = naranja
# #F57C00, Unidades = amarillo #FBC02D. Los graficos de serie simple usan el color de
# su metrica; los apilados/pivoteados (por Canal, Marca Propia) mantienen la paleta
# completa porque sus series representan categorias, no la metrica.
# =============================================================================

- dashboard: venta_integral
  title: "Venta Integral"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Venta Integral unificado: Home, Tickets, Unidades, Ventas en $ y Remitos en un solo dashboard con tabs."

  tabs:
  - name: home
    label: "Home"
  - name: ventas
    label: "Ventas"
  - name: tickets
    label: "Tickets"
  - name: unidades
    label: "Unidades"
  - name: remitos
    label: "Remitos"

  # ---------------- Filtros globales (compartidos por todas las tabs) ----------------
  filters:
  - name: fecha
    title: "Fecha"
    type: field_filter
    default_value: "2026"
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
  - name: provincia
    title: "Provincia"
    type: field_filter
    model: lakehouse
    explore: fct_ventas
    field: dim_provincia.provincia
  - name: sucursal
    title: "Sucursal"
    type: field_filter
    model: lakehouse
    explore: fct_ventas
    field: dim_sucursal.sucursal_cod_desc
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
  - name: dispensa
    title: "Tipo Dispensa"
    type: field_filter
    model: lakehouse
    explore: fct_remitos
    field: fct_remitos.tipo_dispensa
  - name: obrasocial
    title: "Obra Social"
    type: field_filter
    model: lakehouse
    explore: fct_remitos
    field: dim_obrasocial.obrasocial

  elements:
  # =====================================================================
  # TAB: HOME
  # =====================================================================
  - title: "Ventas"
    name: h_kpi_ventas
    tab_name: home
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.venta_periodo, fct_ventas.venta_yoy]
    show_single_value_title: true
    single_value_title: "Ventas"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    custom_color_enabled: true
    custom_color: "#2E7D32"
    show_comparison_label: false
    listen: { fecha: fct_ventas.filtro_fecha, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 0
    width: 8
    height: 3
  - title: "Tickets"
    name: h_kpi_tickets
    tab_name: home
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.tickets_periodo, fct_ventas.tickets_yoy]
    show_single_value_title: true
    single_value_title: "Tickets"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    custom_color_enabled: true
    custom_color: "#F57C00"
    show_comparison_label: false
    listen: { fecha: fct_ventas.filtro_fecha, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 8
    width: 8
    height: 3
  - title: "Unidades"
    name: h_kpi_unidades
    tab_name: home
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.unidades_periodo, fct_ventas.unidades_yoy]
    show_single_value_title: true
    single_value_title: "Unidades"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    custom_color_enabled: true
    custom_color: "#FBC02D"
    show_comparison_label: false
    listen: { fecha: fct_ventas.filtro_fecha, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 16
    width: 8
    height: 3
  - title: "Ventas por dia"
    name: h_trend_ventas
    tab_name: home
    model: lakehouse
    explore: fct_ventas
    type: looker_area
    colors: ["#2E7D32"]
    fields: [dim_fecha.fecha_date, fct_ventas.venta_neta]
    sorts: [dim_fecha.fecha_date]
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 3
    col: 0
    width: 8
    height: 6
  - title: "Tickets por dia"
    name: h_trend_tickets
    tab_name: home
    model: lakehouse
    explore: fct_ventas
    type: looker_area
    colors: ["#F57C00"]
    fields: [dim_fecha.fecha_date, fct_ventas.tickets]
    sorts: [dim_fecha.fecha_date]
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 3
    col: 8
    width: 8
    height: 6
  - title: "Unidades por dia"
    name: h_trend_unidades
    tab_name: home
    model: lakehouse
    explore: fct_ventas
    type: looker_area
    colors: ["#FBC02D"]
    fields: [dim_fecha.fecha_date, fct_ventas.unidades]
    sorts: [dim_fecha.fecha_date]
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 3
    col: 16
    width: 8
    height: 6
  - title: "Ticket Promedio"
    name: h_kpi_tktprom
    tab_name: home
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.ticket_promedio_periodo, fct_ventas.ticket_promedio_yoy]
    show_single_value_title: true
    single_value_title: "Ticket Promedio"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    custom_color_enabled: true
    custom_color: "#2E7D32"
    show_comparison_label: false
    listen: { fecha: fct_ventas.filtro_fecha, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 9
    col: 0
    width: 5
    height: 5
  - title: "Unidades por Ticket"
    name: h_kpi_uxt
    tab_name: home
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.unidades_por_ticket_periodo, fct_ventas.unidades_por_ticket_yoy]
    show_single_value_title: true
    single_value_title: "Unidades por Ticket"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    custom_color_enabled: true
    custom_color: "#FBC02D"
    show_comparison_label: false
    listen: { fecha: fct_ventas.filtro_fecha, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 9
    col: 5
    width: 5
    height: 5
  - title: "Margen %"
    name: h_kpi_margenpct
    tab_name: home
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.margen_pct_periodo, fct_ventas.margen_pct_yoy]
    show_single_value_title: true
    single_value_title: "Margen %"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    custom_color_enabled: true
    custom_color: "#2E7D32"
    show_comparison_label: false
    listen: { fecha: fct_ventas.filtro_fecha, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 9
    col: 10
    width: 5
    height: 5
  - title: "Margen $"
    name: h_kpi_margen
    tab_name: home
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.margen_periodo, fct_ventas.margen_yoy]
    show_single_value_title: true
    single_value_title: "Margen $"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    custom_color_enabled: true
    custom_color: "#2E7D32"
    show_comparison_label: false
    listen: { fecha: fct_ventas.filtro_fecha, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 9
    col: 15
    width: 5
    height: 5
  - title: "Remitos"
    name: h_kpi_remitos
    tab_name: home
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.remitos_periodo, fct_remitos.remitos_yoy]
    show_single_value_title: true
    single_value_title: "Remitos"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    custom_color_enabled: true
    custom_color: "#F57C00"
    show_comparison_label: false
    listen: { fecha: fct_remitos.filtro_fecha, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, marca: dim_marca.marca, marca_propia: dim_articulo.marca_propia }
    row: 9
    col: 20
    width: 4
    height: 5
  - title: "Resumen por Formato (2026 vs Año Anterior)"
    name: h_formato
    tab_name: home
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    table_theme: white
    show_row_numbers: false
    size_to_fit: true
    header_background_color: "#2E7D32"
    header_font_color: "#FFFFFF"
    header_text_alignment: left
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
    listen: { formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 14
    col: 0
    width: 24
    height: 10
  - title: "Resumen por Tienda (2026 vs Año Anterior)"
    name: h_tienda
    tab_name: home
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    table_theme: white
    show_row_numbers: false
    size_to_fit: true
    header_background_color: "#2E7D32"
    header_font_color: "#FFFFFF"
    header_text_alignment: left
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
    listen: { formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 24
    col: 0
    width: 24
    height: 10

  # =====================================================================
  # TAB: TICKETS  (metrica principal: Tickets -> naranja #F57C00)
  # =====================================================================
  - title: "Tickets por Formato"
    name: t_formato
    tab_name: tickets
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    table_theme: white
    show_row_numbers: false
    size_to_fit: true
    header_background_color: "#2E7D32"
    header_font_color: "#FFFFFF"
    header_text_alignment: left
    fields: [dim_formato.formato, fct_ventas.tickets, fct_ventas.pct_tickets_total]
    sorts: [fct_ventas.tickets desc]
    series_cell_visualizations: { fct_ventas.tickets: { is_active: false } }
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 0
    width: 6
    height: 13
  - title: "Tickets por Canal"
    name: t_canal
    tab_name: tickets
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    colors: ["#2E7D32", "#F57C00", "#66BB6A", "#FB8C00", "#1B5E20", "#E65100"]
    fields: [dim_origenventa.canal, fct_ventas.tickets]
    pivots: [dim_origenventa.canal]
    sorts: [fct_ventas.tickets desc]
    stacking: percent
    show_value_labels: true
    filters:
      fct_ventas.tickets: ">=57000"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 6
    width: 10
    height: 5
  - title: "Top Marcas - Tickets"
    name: t_marcas
    tab_name: tickets
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    table_theme: white
    show_row_numbers: false
    size_to_fit: true
    header_background_color: "#2E7D32"
    header_font_color: "#FFFFFF"
    header_text_alignment: left
    fields: [dim_marca.marca, fct_ventas.tickets]
    sorts: [fct_ventas.tickets desc]
    limit: 15
    series_cell_visualizations: { fct_ventas.tickets: { is_active: false } }
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 16
    width: 8
    height: 13
  - title: "Marca Propia vs Resto (unidades)"
    name: t_marcapropia
    tab_name: tickets
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    colors: ["#2E7D32", "#F57C00", "#66BB6A", "#FB8C00", "#1B5E20", "#E65100"]
    fields: [dim_articulo.marca_propia, fct_ventas.unidades]
    pivots: [dim_articulo.marca_propia]
    sorts: [fct_ventas.unidades desc]
    stacking: percent
    show_value_labels: true
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 5
    col: 6
    width: 10
    height: 3
  - title: "Participacion por Departamento"
    name: t_depto
    tab_name: tickets
    model: lakehouse
    explore: fct_ventas
    type: looker_column
    colors: ["#F57C00"]
    fields: [dim_departamento.departamento, fct_ventas.pct_tickets_total]
    sorts: [fct_ventas.pct_tickets_total desc]
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 8
    col: 6
    width: 10
    height: 5
  - title: "Top 10 Categorias - Tickets"
    name: t_categorias
    tab_name: tickets
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    colors: ["#F57C00"]
    fields: [dim_categoria.categoria, fct_ventas.tickets]
    sorts: [fct_ventas.tickets desc]
    limit: 10
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 0
    width: 12
    height: 9
  - title: "Top Productos - Tickets"
    name: t_productos
    tab_name: tickets
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    table_theme: white
    show_row_numbers: false
    size_to_fit: true
    header_background_color: "#2E7D32"
    header_font_color: "#FFFFFF"
    header_text_alignment: left
    fields: [dim_articulo.producto, fct_ventas.tickets]
    sorts: [fct_ventas.tickets desc]
    limit: 20
    series_cell_visualizations: { fct_ventas.tickets: { is_active: false } }
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 12
    width: 12
    height: 9

  # =====================================================================
  # TAB: UNIDADES  (metrica principal: Unidades -> amarillo #FBC02D)
  # =====================================================================
  - title: "Unidades por Formato"
    name: u_formato
    tab_name: unidades
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    table_theme: white
    show_row_numbers: false
    size_to_fit: true
    header_background_color: "#2E7D32"
    header_font_color: "#FFFFFF"
    header_text_alignment: left
    fields: [dim_formato.formato, fct_ventas.unidades, fct_ventas.pct_unidades_total]
    sorts: [fct_ventas.unidades desc]
    series_cell_visualizations: { fct_ventas.unidades: { is_active: false } }
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 0
    width: 6
    height: 13
  - title: "Unidades por Canal"
    name: u_canal
    tab_name: unidades
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    colors: ["#2E7D32", "#F57C00", "#66BB6A", "#FB8C00", "#1B5E20", "#E65100"]
    fields: [dim_origenventa.canal, fct_ventas.unidades]
    pivots: [dim_origenventa.canal]
    sorts: [fct_ventas.unidades desc]
    stacking: percent
    show_value_labels: true
    filters:
      fct_ventas.unidades: ">=227000"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 6
    width: 10
    height: 5
  - title: "Top Marcas - Unidades"
    name: u_marcas
    tab_name: unidades
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    table_theme: white
    show_row_numbers: false
    size_to_fit: true
    header_background_color: "#2E7D32"
    header_font_color: "#FFFFFF"
    header_text_alignment: left
    fields: [dim_marca.marca, fct_ventas.unidades]
    sorts: [fct_ventas.unidades desc]
    limit: 15
    series_cell_visualizations: { fct_ventas.unidades: { is_active: false } }
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 16
    width: 8
    height: 13
  - title: "Marca Propia vs Resto (unidades)"
    name: u_marcapropia
    tab_name: unidades
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    colors: ["#2E7D32", "#F57C00", "#66BB6A", "#FB8C00", "#1B5E20", "#E65100"]
    fields: [dim_articulo.marca_propia, fct_ventas.unidades]
    pivots: [dim_articulo.marca_propia]
    sorts: [fct_ventas.unidades desc]
    stacking: percent
    show_value_labels: true
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 5
    col: 6
    width: 10
    height: 3
  - title: "Participacion por Departamento"
    name: u_depto
    tab_name: unidades
    model: lakehouse
    explore: fct_ventas
    type: looker_column
    colors: ["#FBC02D"]
    fields: [dim_departamento.departamento, fct_ventas.pct_unidades_total]
    sorts: [fct_ventas.pct_unidades_total desc]
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 8
    col: 6
    width: 10
    height: 5
  - title: "Top 10 Categorias - Unidades"
    name: u_categorias
    tab_name: unidades
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    colors: ["#FBC02D"]
    fields: [dim_categoria.categoria, fct_ventas.unidades]
    sorts: [fct_ventas.unidades desc]
    limit: 10
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 0
    width: 8
    height: 9
  - title: "Top Productos - Unidades"
    name: u_productos
    tab_name: unidades
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    table_theme: white
    show_row_numbers: false
    size_to_fit: true
    header_background_color: "#2E7D32"
    header_font_color: "#FFFFFF"
    header_text_alignment: left
    fields: [dim_articulo.producto, fct_ventas.unidades]
    sorts: [fct_ventas.unidades desc]
    limit: 20
    series_cell_visualizations: { fct_ventas.unidades: { is_active: false } }
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 8
    width: 8
    height: 9

  # =====================================================================
  # TAB: VENTAS EN $  (metrica principal: Ventas -> verde #2E7D32)
  # =====================================================================
  - title: "Ventas por Formato"
    name: v_formato
    tab_name: ventas
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    table_theme: white
    show_row_numbers: false
    size_to_fit: true
    header_background_color: "#2E7D32"
    header_font_color: "#FFFFFF"
    header_text_alignment: left
    fields: [dim_formato.formato, fct_ventas.venta_neta, fct_ventas.pct_venta_total]
    sorts: [fct_ventas.venta_neta desc]
    series_cell_visualizations: { fct_ventas.venta_neta: { is_active: false } }
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 0
    width: 6
    height: 13
  - title: "Ventas por Canal"
    name: v_canal
    tab_name: ventas
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    colors: ["#2E7D32", "#F57C00", "#66BB6A", "#FB8C00", "#1B5E20", "#E65100"]
    fields: [dim_origenventa.canal, fct_ventas.venta_neta]
    pivots: [dim_origenventa.canal]
    sorts: [fct_ventas.venta_neta desc]
    stacking: percent
    show_value_labels: true
    filters:
      fct_ventas.venta_neta: ">=1920000000"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 6
    width: 10
    height: 5
  - title: "Top Marcas - Venta y Margen $"
    name: v_marcas
    tab_name: ventas
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    table_theme: white
    show_row_numbers: false
    size_to_fit: true
    header_background_color: "#2E7D32"
    header_font_color: "#FFFFFF"
    header_text_alignment: left
    fields: [dim_marca.marca, fct_ventas.venta_neta, fct_ventas.margen_pesos]
    sorts: [fct_ventas.venta_neta desc]
    limit: 15
    series_cell_visualizations: { fct_ventas.venta_neta: { is_active: false } }
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 0
    col: 16
    width: 8
    height: 13
  - title: "Marca Propia vs Resto (venta)"
    name: v_marcapropia
    tab_name: ventas
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    colors: ["#2E7D32", "#F57C00", "#66BB6A", "#FB8C00", "#1B5E20", "#E65100"]
    fields: [dim_articulo.marca_propia, fct_ventas.venta_neta]
    pivots: [dim_articulo.marca_propia]
    sorts: [fct_ventas.venta_neta desc]
    stacking: percent
    show_value_labels: true
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 5
    col: 6
    width: 10
    height: 3
  - title: "Participacion por Departamento"
    name: v_depto
    tab_name: ventas
    model: lakehouse
    explore: fct_ventas
    type: looker_column
    colors: ["#2E7D32"]
    fields: [dim_departamento.departamento, fct_ventas.pct_venta_total]
    sorts: [fct_ventas.pct_venta_total desc]
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 8
    col: 6
    width: 10
    height: 5
  - title: "Top 10 Categorias - Venta"
    name: v_categorias
    tab_name: ventas
    model: lakehouse
    explore: fct_ventas
    type: looker_bar
    colors: ["#2E7D32"]
    fields: [dim_categoria.categoria, fct_ventas.venta_neta]
    sorts: [fct_ventas.venta_neta desc]
    limit: 10
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 0
    width: 8
    height: 9
  - title: "Top Productos - Venta"
    name: v_productos
    tab_name: ventas
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    table_theme: white
    show_row_numbers: false
    size_to_fit: true
    header_background_color: "#2E7D32"
    header_font_color: "#FFFFFF"
    header_text_alignment: left
    fields: [dim_articulo.producto, fct_ventas.venta_neta]
    sorts: [fct_ventas.venta_neta desc]
    limit: 20
    series_cell_visualizations: { fct_ventas.venta_neta: { is_active: false } }
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca, canal: dim_origenventa.canal, marca_propia: dim_articulo.marca_propia }
    row: 13
    col: 8
    width: 8
    height: 9

  # =====================================================================
  # TAB: REMITOS  (Venta -> verde, Remitos -> naranja, Unidades -> amarillo)
  # =====================================================================
  - title: "Venta Remitos $"
    name: r_kpi_venta
    tab_name: remitos
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.venta_periodo, fct_remitos.venta_yoy]
    show_single_value_title: true
    single_value_title: "Venta Remitos $"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    custom_color_enabled: true
    custom_color: "#2E7D32"
    show_comparison_label: false
    listen: { fecha: fct_remitos.filtro_fecha, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 0
    col: 0
    width: 8
    height: 5
  - title: "Remitos"
    name: r_kpi_remitos
    tab_name: remitos
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.remitos_periodo, fct_remitos.remitos_yoy]
    show_single_value_title: true
    single_value_title: "Remitos"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    custom_color_enabled: true
    custom_color: "#F57C00"
    show_comparison_label: false
    listen: { fecha: fct_remitos.filtro_fecha, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 0
    col: 8
    width: 8
    height: 5
  - title: "Unidades Remitos"
    name: r_kpi_unidades
    tab_name: remitos
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.unidades_periodo, fct_remitos.unidades_yoy]
    show_single_value_title: true
    single_value_title: "Unidades Remitos"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    custom_color_enabled: true
    custom_color: "#FBC02D"
    show_comparison_label: false
    listen: { fecha: fct_remitos.filtro_fecha, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 0
    col: 16
    width: 8
    height: 5
  - title: "Remito Promedio"
    name: r_kpi_promedio
    tab_name: remitos
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.remito_promedio_periodo, fct_remitos.remito_promedio_yoy]
    show_single_value_title: true
    single_value_title: "Remito Promedio"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    custom_color_enabled: true
    custom_color: "#2E7D32"
    show_comparison_label: false
    listen: { fecha: fct_remitos.filtro_fecha, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 5
    col: 0
    width: 6
    height: 5
  - title: "Unidades por Remito"
    name: r_kpi_uxr
    tab_name: remitos
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.unidades_por_remito_periodo, fct_remitos.unidades_por_remito_yoy]
    show_single_value_title: true
    single_value_title: "Unidades por Remito"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    custom_color_enabled: true
    custom_color: "#FBC02D"
    show_comparison_label: false
    listen: { fecha: fct_remitos.filtro_fecha, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 5
    col: 6
    width: 6
    height: 5
  - title: "Margen %"
    name: r_kpi_margenpct
    tab_name: remitos
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.margen_pct_periodo, fct_remitos.margen_pct_yoy]
    show_single_value_title: true
    single_value_title: "Margen %"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    custom_color_enabled: true
    custom_color: "#2E7D32"
    show_comparison_label: false
    listen: { fecha: fct_remitos.filtro_fecha, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 5
    col: 12
    width: 6
    height: 5
  - title: "Margen $"
    name: r_kpi_margen
    tab_name: remitos
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.margen_periodo, fct_remitos.margen_yoy]
    show_single_value_title: true
    single_value_title: "Margen $"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    custom_color_enabled: true
    custom_color: "#2E7D32"
    show_comparison_label: false
    listen: { fecha: fct_remitos.filtro_fecha, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 5
    col: 18
    width: 6
    height: 5
  - title: "Venta Remitos por dia"
    name: r_trend_venta
    tab_name: remitos
    model: lakehouse
    explore: fct_remitos
    type: looker_area
    colors: ["#2E7D32"]
    fields: [dim_fecha.fecha_date, fct_remitos.venta_remito]
    sorts: [dim_fecha.fecha_date]
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 10
    col: 0
    width: 24
    height: 8
  - title: "Remitos por dia"
    name: r_trend_remitos
    tab_name: remitos
    model: lakehouse
    explore: fct_remitos
    type: looker_area
    colors: ["#F57C00"]
    fields: [dim_fecha.fecha_date, fct_remitos.remitos]
    sorts: [dim_fecha.fecha_date]
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 18
    col: 0
    width: 12
    height: 7
  - title: "Unidades Remitos por dia"
    name: r_trend_unidades
    tab_name: remitos
    model: lakehouse
    explore: fct_remitos
    type: looker_area
    colors: ["#FBC02D"]
    fields: [dim_fecha.fecha_date, fct_remitos.unidades_remito]
    sorts: [dim_fecha.fecha_date]
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 18
    col: 12
    width: 12
    height: 7
  - title: "Detalle por Tipo Dispensa"
    name: r_dispensa
    tab_name: remitos
    model: lakehouse
    explore: fct_remitos
    type: looker_grid
    table_theme: white
    show_row_numbers: false
    size_to_fit: true
    header_background_color: "#2E7D32"
    header_font_color: "#FFFFFF"
    header_text_alignment: left
    fields: [fct_remitos.tipo_dispensa, fct_remitos.venta_remito, fct_remitos.pct_venta_total, fct_remitos.remitos, fct_remitos.pct_remitos_total, fct_remitos.unidades_remito, fct_remitos.pct_unidades_total]
    sorts: [fct_remitos.venta_remito desc]
    series_cell_visualizations: { fct_remitos.venta_remito: { is_active: true } }
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 25
    col: 0
    width: 24
    height: 9
  - title: "Top Productos - Remitos"
    name: r_productos
    tab_name: remitos
    model: lakehouse
    explore: fct_remitos
    type: looker_grid
    table_theme: white
    show_row_numbers: false
    size_to_fit: true
    header_background_color: "#2E7D32"
    header_font_color: "#FFFFFF"
    header_text_alignment: left
    fields: [dim_articulo.producto, fct_remitos.venta_remito, fct_remitos.unidades_remito]
    sorts: [fct_remitos.venta_remito desc]
    limit: 20
    series_cell_visualizations: { fct_remitos.venta_remito: { is_active: false } }
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, provincia: dim_provincia.provincia, sucursal: dim_sucursal.sucursal_cod_desc, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 34
    col: 0
    width: 24
    height: 9
