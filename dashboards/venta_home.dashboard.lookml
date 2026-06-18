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
#  - Filtros nuevos: Año (para la tabla final), Departamento, Categoria, Marca
#    (todos con DIM). Canal/Marca Propia/Negocio pendientes de confirmar fuente.
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
    field: fct_ventas.dia_date
    allow_multiple_values: true
    required: false
  - name: anio
    title: "Año (tabla final)"
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
  # PENDIENTE (fuente a confirmar en BigQuery, ver fuentes_vistas_venta_integral.xlsx):
  # Canal (Dim Origen), Marca Propia (flag sin poblar) y Negocio (sin tabla de
  # segmento). Se agregan como filtros cuando se confirme la fuente.

  elements:
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
    fields: [fct_ventas.venta_neta, fct_ventas.dia_year]
    pivots: [fct_ventas.dia_year]
    filters:
      fct_ventas.dia_date: "2025/03/01 to 2026/04/01"
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year]
    hidden_fields: [fct_ventas.venta_neta]
    dynamic_fields:
    - table_calculation: kpi_ventas
      label: "Ventas"
      expression: "pivot_index(${fct_ventas.venta_neta}, 2)"
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_ventas_ant
      label: "Año Ant"
      expression: "pivot_index(${fct_ventas.venta_neta}, 1)"
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Ventas (mar 2026 vs 2025)"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca }
    row: 0
    col: 0
    width: 8
    height: 4
  - title: "Tickets"
    name: h_kpi_tickets
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.tickets, fct_ventas.dia_year]
    pivots: [fct_ventas.dia_year]
    filters:
      fct_ventas.dia_date: "2025/03/01 to 2026/04/01"
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year]
    hidden_fields: [fct_ventas.tickets]
    dynamic_fields:
    - table_calculation: kpi_tickets
      label: "Tickets"
      expression: "pivot_index(${fct_ventas.tickets}, 2)"
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_tickets_ant
      label: "Año Ant"
      expression: "pivot_index(${fct_ventas.tickets}, 1)"
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Tickets (mar 2026 vs 2025)"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca }
    row: 0
    col: 8
    width: 8
    height: 4
  - title: "Unidades"
    name: h_kpi_unidades
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.unidades, fct_ventas.dia_year]
    pivots: [fct_ventas.dia_year]
    filters:
      fct_ventas.dia_date: "2025/03/01 to 2026/04/01"
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year]
    hidden_fields: [fct_ventas.unidades]
    dynamic_fields:
    - table_calculation: kpi_unidades
      label: "Unidades"
      expression: "pivot_index(${fct_ventas.unidades}, 2)"
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_unidades_ant
      label: "Año Ant"
      expression: "pivot_index(${fct_ventas.unidades}, 1)"
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Unidades (mar 2026 vs 2025)"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca }
    row: 0
    col: 16
    width: 8
    height: 4

  # ---------------- KPIs fila 2: ratios + Remitos (con YoY) ----------------
  - title: "Ticket Promedio"
    name: h_kpi_tktprom
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.ticket_promedio, fct_ventas.dia_year]
    pivots: [fct_ventas.dia_year]
    filters:
      fct_ventas.dia_date: "2025/03/01 to 2026/04/01"
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year]
    hidden_fields: [fct_ventas.ticket_promedio]
    dynamic_fields:
    - table_calculation: kpi_tktprom
      label: "Ticket Promedio"
      expression: "pivot_index(${fct_ventas.ticket_promedio}, 2)"
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_tktprom_ant
      label: "Año Ant"
      expression: "pivot_index(${fct_ventas.ticket_promedio}, 1)"
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Ticket Prom (mar 26 vs 25)"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca }
    row: 4
    col: 0
    width: 5
    height: 3
  - title: "Unidades por Ticket"
    name: h_kpi_uxt
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.unidades_por_ticket, fct_ventas.dia_year]
    pivots: [fct_ventas.dia_year]
    filters:
      fct_ventas.dia_date: "2025/03/01 to 2026/04/01"
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year]
    hidden_fields: [fct_ventas.unidades_por_ticket]
    dynamic_fields:
    - table_calculation: kpi_uxt
      label: "Unidades por Ticket"
      expression: "pivot_index(${fct_ventas.unidades_por_ticket}, 2)"
      value_format_name: decimal_2
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_uxt_ant
      label: "Año Ant"
      expression: "pivot_index(${fct_ventas.unidades_por_ticket}, 1)"
      value_format_name: decimal_2
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Unid x Ticket (mar 26 vs 25)"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca }
    row: 4
    col: 5
    width: 5
    height: 3
  - title: "Margen %"
    name: h_kpi_margenpct
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.margen_pct, fct_ventas.dia_year]
    pivots: [fct_ventas.dia_year]
    filters:
      fct_ventas.dia_date: "2025/03/01 to 2026/04/01"
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year]
    hidden_fields: [fct_ventas.margen_pct]
    dynamic_fields:
    - table_calculation: kpi_margenpct
      label: "Margen %"
      expression: "pivot_index(${fct_ventas.margen_pct}, 2)"
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_margenpct_ant
      label: "Año Ant"
      expression: "pivot_index(${fct_ventas.margen_pct}, 1)"
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Margen % (mar 26 vs 25)"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca }
    row: 4
    col: 10
    width: 5
    height: 3
  - title: "Margen $"
    name: h_kpi_margen
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.margen_pesos, fct_ventas.dia_year]
    pivots: [fct_ventas.dia_year]
    filters:
      fct_ventas.dia_date: "2025/03/01 to 2026/04/01"
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year]
    hidden_fields: [fct_ventas.margen_pesos]
    dynamic_fields:
    - table_calculation: kpi_margen
      label: "Margen $"
      expression: "pivot_index(${fct_ventas.margen_pesos}, 2)"
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_margen_ant
      label: "Año Ant"
      expression: "pivot_index(${fct_ventas.margen_pesos}, 1)"
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Margen $ (mar 26 vs 25)"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca }
    row: 4
    col: 15
    width: 5
    height: 3
  - title: "Remitos"
    name: h_kpi_remitos
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.remitos, fct_remitos.dia_year]
    pivots: [fct_remitos.dia_year]
    filters:
      fct_remitos.dia_date: "2025/03/01 to 2026/04/01"
      fct_remitos.dia_month: "2025-03, 2026-03"
    sorts: [fct_remitos.dia_year]
    hidden_fields: [fct_remitos.remitos]
    dynamic_fields:
    - table_calculation: kpi_remitos
      label: "Remitos"
      expression: "pivot_index(${fct_remitos.remitos}, 2)"
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: kpi_remitos_ant
      label: "Año Ant"
      expression: "pivot_index(${fct_remitos.remitos}, 1)"
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Remitos (mar 26 vs 25)"
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    listen: { formato: dim_formato.formato, departamento: dim_departamento.departamento }
    row: 4
    col: 20
    width: 4
    height: 3

  # ---------------- Tabla por Formato con variacion interanual ----------------
  # Pivote por anio. Trae marzo 2024, 2025 y 2026 para que las columnas "Año Ant"
  # del 2025 (2025 vs 2024) Y del 2026 (2026 vs 2025) muestren valor. El 2024 es el
  # anio base, por eso su "Año Ant" queda en blanco (no hay 2023 en la consulta).
  # Filtro de meses fijo en el tile (no escucha "fecha"); escucha "anio" (dia_year),
  # "formato", "departamento", "categoria" y "marca".
  - title: "Resumen por Formato (vs Año Anterior)"
    name: h_formato
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_formato.formato, fct_ventas.dia_year, fct_ventas.venta_neta, fct_ventas.tickets, fct_ventas.unidades]
    pivots: [fct_ventas.dia_year]
    # dia_date acota el rango y SOBRE-ESCRIBE el always_filter "1 months" del explore;
    # dia_month deja los tres marzos (2024/2025/2026).
    filters:
      fct_ventas.dia_date: "2024/03/01 to 2026/04/01"
      fct_ventas.dia_month: "2024-03, 2025-03, 2026-03"
    sorts: [fct_ventas.dia_year, fct_ventas.venta_neta desc]
    dynamic_fields:
    - table_calculation: ventas_anio_ant
      label: "Ventas Año Ant"
      expression: "${fct_ventas.venta_neta}/pivot_offset(${fct_ventas.venta_neta},-1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    - table_calculation: tickets_anio_ant
      label: "Tickets Año Ant"
      expression: "${fct_ventas.tickets}/pivot_offset(${fct_ventas.tickets},-1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    - table_calculation: unidades_anio_ant
      label: "Unidades Año Ant"
      expression: "${fct_ventas.unidades}/pivot_offset(${fct_ventas.unidades},-1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    listen: { anio: fct_ventas.dia_year, formato: dim_formato.formato, departamento: dim_departamento.departamento, categoria: dim_categoria.categoria, marca: dim_marca.marca }
    row: 7
    col: 0
    width: 24
    height: 10

  # ---------------- Nota de GAPs ----------------
  - name: h_gaps
    type: text
    title_text: "Pendientes (no migrados de BigQuery)"
    body_text: "Bloque Retail/Farmacia por Id Canal: columna calculada en SSAS, no existe en BQ (reproducir en ETL). KPIs con YoY anclados a marzo (no siguen el filtro Fecha); para KPIs dinamicos por periodo libre + YoY hay que precalcular MMAA en BigQuery. Presencial vs No Presencial: pendiente de confirmar la Dim Origen (Canal)."
    row: 17
    col: 0
    width: 24
    height: 2
