# =============================================================================
# Dashboard: Venta Integral - Home   (PBI: "Total" / portada Venta Integral)
# Resumen ejecutivo: Ventas, Tickets, Unidades + ratios y tabla por Formato.
#
# Reconciliacion marzo 2026 (vs HOME.png):
#  - Ventas 192.01B (cap 192.10B) / Tickets 5.71M (5.68M) / Unidades 22.78M (22.43M)
#  - Margen % 29.4% (29.75%) / Remitos ~2.45M (2.443M)
#  Variacion interanual Ventas por Formato (vs captura tabla "Ano Ant"):
#  - Farmacity +35.0% (cap +35.3%), Simplicity +25.7% (+25.2%),
#    Farmacity.com/ML +36.5% (+37.1%), The Food Market +34.6% (+33.1%),
#    Get The Look -15.3% (-9.2%). La diferencia en Get The Look es el ajuste de
#    bisiesto/Madurez del cubo (SAMEPERIODLASTYEAR), no replicado.
#
# DECISIONES (acordadas con el usuario):
#  - Bloque "Retail 184B / Farmacia 7.63B": OMITIDO. El split es por Id Canal,
#    columna calculada DAX que NO existe en BigQuery (verificado: no es obra
#    social, que da 96B/96B). Reproducir Id Canal en el ETL para habilitarlo.
#  - Interanual ("Ano Ant"): table calc con pivote por anio (sin precalcular en
#    BQ). La tabla de Formato compara marzo 2025 vs marzo 2026 (meses fijos);
#    para que siga otros periodos haria falta precalcular MMAA en BigQuery.
#  - Badges "2025: %" en los KPIs: requieren medidas MMAA (precalc en BQ); no se
#    pueden en un single_value con solo table calc, por eso no van por ahora.
# =============================================================================

- dashboard: venta_home
  title: "Venta Integral - Home"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Resumen ejecutivo: Ventas, Tickets, Unidades, margen y tabla por Formato con variacion interanual."

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

  elements:
  # ---------------- KPIs fila 1: Ventas / Tickets / Unidades ----------------
  - title: "Ventas"
    name: h_kpi_ventas
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.venta_neta]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 0
    col: 0
    width: 8
    height: 4
  - title: "Tickets"
    name: h_kpi_tickets
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.tickets]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 0
    col: 8
    width: 8
    height: 4
  - title: "Unidades"
    name: h_kpi_unidades
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.unidades]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 0
    col: 16
    width: 8
    height: 4

  # ---------------- KPIs fila 2: ratios + Remitos ----------------
  - title: "Ticket Promedio"
    name: h_kpi_tktprom
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.ticket_promedio]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 4
    col: 0
    width: 5
    height: 3
  - title: "Unidades por Ticket"
    name: h_kpi_uxt
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.unidades_por_ticket]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 4
    col: 5
    width: 5
    height: 3
  - title: "Margen %"
    name: h_kpi_margenpct
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.margen_pct]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 4
    col: 10
    width: 5
    height: 3
  - title: "Margen $"
    name: h_kpi_margen
    model: lakehouse
    explore: fct_ventas
    type: single_value
    fields: [fct_ventas.margen_pesos]
    listen: { fecha: fct_ventas.dia_date, formato: dim_formato.formato }
    row: 4
    col: 15
    width: 5
    height: 3
  - title: "Remitos"
    name: h_kpi_remitos
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.remitos]
    listen: { fecha: fct_remitos.dia_date, formato: dim_formato.formato }
    row: 4
    col: 20
    width: 4
    height: 3

  # ---------------- Tabla por Formato con variacion interanual ----------------
  # Pivote por anio (marzo 2025 vs marzo 2026); las columnas "Ano Ant" son table
  # calcs %. Filtro de meses fijo en el tile (no escucha "fecha") para traer ambos
  # anios; "formato" si se escucha.
  - title: "Resumen por Formato (vs Ano Anterior)"
    name: h_formato
    model: lakehouse
    explore: fct_ventas
    type: looker_grid
    fields: [dim_formato.formato, fct_ventas.dia_year, fct_ventas.venta_neta, fct_ventas.tickets, fct_ventas.unidades]
    pivots: [fct_ventas.dia_year]
    filters:
      fct_ventas.dia_month: "2025-03, 2026-03"
    sorts: [fct_ventas.dia_year, fct_ventas.venta_neta desc]
    dynamic_fields:
    - table_calculation: ventas_anio_ant
      label: "Ventas Ano Ant"
      expression: "${fct_ventas.venta_neta}/pivot_offset(${fct_ventas.venta_neta},-1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    - table_calculation: tickets_anio_ant
      label: "Tickets Ano Ant"
      expression: "${fct_ventas.tickets}/pivot_offset(${fct_ventas.tickets},-1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    - table_calculation: unidades_anio_ant
      label: "Unidades Ano Ant"
      expression: "${fct_ventas.unidades}/pivot_offset(${fct_ventas.unidades},-1)-1"
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    listen: { formato: dim_formato.formato }
    row: 7
    col: 0
    width: 24
    height: 10

  # ---------------- Nota de GAPs ----------------
  - name: h_gaps
    type: text
    title_text: "Pendientes (no migrados de BigQuery)"
    body_text: "Bloque Retail/Farmacia por Id Canal: columna calculada en SSAS, no existe en BQ (reproducir en ETL). Badges interanuales en los KPIs y comparativa por periodo libre: requieren precalcular MMAA en BigQuery."
    row: 17
    col: 0
    width: 24
    height: 2
