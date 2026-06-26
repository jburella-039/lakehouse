# =============================================================================
# Dashboard: Venta Integral - Remitos   (PBI: "Farmacia")
# Fuente: explore fct_remitos (BT_VTA_FARMACIA). Medidas de la tabla Remito.
#
# Reconciliacion marzo 2026 (ver fct_remitos.view): definiciones confirmadas por
# el cruce de margen; el nivel absoluto queda ~3% sobre la captura por estado de
# slicers (igual que las otras 3 paginas).
#
# Interanual: las tarjetas KPI muestran la comparacion vs anio anterior
# (comparison_type: change) via pivote por anio + pivot_index, con periodo FIJO
# marzo 2026 vs 2025 (no siguen el filtro "Fecha"). Para KPIs dinamicos por
# periodo libre + YoY haria falta precalcular MMAA en BigQuery. Falta validar el
# render del single_value con comparacion en Looker.
# =============================================================================

- dashboard: venta_remitos
  title: "Venta Integral - Remitos"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Remitos de farmacia (obra social / dispensa): venta, remitos, unidades y margen."

  filters:
  - name: fecha
    title: "Fecha"
    type: field_filter
    default_value: "2026/03/01 to 2026/04/01"
    model: lakehouse
    explore: fct_remitos
    field: dim_fecha.fecha_date
    allow_multiple_values: true
    required: false
  - name: anio
    title: "Año"
    type: field_filter
    model: lakehouse
    explore: fct_remitos
    field: dim_fecha.anio_sel
    allow_multiple_values: false
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
  - name: formato
    title: "Formato"
    type: field_filter
    model: lakehouse
    explore: fct_remitos
    field: dim_formato.formato
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
  # ---------------- Barra de navegacion (botones a las demas paginas) ----------------
  - name: nav
    type: text
    body_text: "<a href='/dashboards/lakehouse::venta_home' style='display:inline-block;padding:7px 14px;margin-right:6px;border-radius:6px;font-weight:600;text-decoration:none;background:#eeeeee;color:#222222;'>Home</a><a href='/dashboards/lakehouse::venta_tickets' style='display:inline-block;padding:7px 14px;margin-right:6px;border-radius:6px;font-weight:600;text-decoration:none;background:#eeeeee;color:#222222;'>Tickets</a><a href='/dashboards/lakehouse::venta_unidades' style='display:inline-block;padding:7px 14px;margin-right:6px;border-radius:6px;font-weight:600;text-decoration:none;background:#eeeeee;color:#222222;'>Unidades</a><a href='/dashboards/lakehouse::venta_ventas' style='display:inline-block;padding:7px 14px;margin-right:6px;border-radius:6px;font-weight:600;text-decoration:none;background:#eeeeee;color:#222222;'>Ventas en $</a><a href='/dashboards/lakehouse::venta_remitos' style='display:inline-block;padding:7px 14px;margin-right:6px;border-radius:6px;font-weight:700;text-decoration:none;background:#000000;color:#ffffff;'>Remitos</a>"
    row: 0
    col: 0
    width: 24
    height: 2

  # ---------------- KPIs fila 1 (con YoY) ----------------
  # Cada tarjeta muestra marzo 2026 y la comparacion % vs marzo 2025
  # (comparison_type: change). Pivote por anio + pivot_index (index 2 = 2026,
  # index 1 = 2025). Periodo FIJO marzo (no escucha "fecha"); para periodo libre
  # + YoY haria falta precalcular MMAA en BigQuery. Falta validar render en Looker.
  - title: "Venta Remitos $"
    name: r_kpi_venta
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.venta_remito]
    hidden_fields: [fct_remitos.venta_remito]
    dynamic_fields:
    - table_calculation: rkpi_venta
      label: "Venta Remitos $"
      expression: "${fct_remitos.venta_remito}"
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Venta Remitos $"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 2
    col: 0
    width: 8
    height: 5
  - title: "Remitos"
    name: r_kpi_remitos
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.remitos]
    hidden_fields: [fct_remitos.remitos]
    dynamic_fields:
    - table_calculation: rkpi_remitos
      label: "Remitos"
      expression: "${fct_remitos.remitos}"
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Remitos"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 2
    col: 8
    width: 8
    height: 5
  - title: "Unidades Remitos"
    name: r_kpi_unidades
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.unidades_remito]
    hidden_fields: [fct_remitos.unidades_remito]
    dynamic_fields:
    - table_calculation: rkpi_unidades
      label: "Unidades Remitos"
      expression: "${fct_remitos.unidades_remito}"
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Unidades Remitos"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 2
    col: 16
    width: 8
    height: 5

  # ---------------- KPIs fila 2 (con YoY) ----------------
  - title: "Remito Promedio"
    name: r_kpi_promedio
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.remito_promedio]
    hidden_fields: [fct_remitos.remito_promedio]
    dynamic_fields:
    - table_calculation: rkpi_promedio
      label: "Remito Promedio"
      expression: "${fct_remitos.remito_promedio}"
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Remito Promedio"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 7
    col: 0
    width: 6
    height: 5
  - title: "Unidades por Remito"
    name: r_kpi_uxr
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.unidades_por_remito]
    hidden_fields: [fct_remitos.unidades_por_remito]
    dynamic_fields:
    - table_calculation: rkpi_uxr
      label: "Unidades por Remito"
      expression: "${fct_remitos.unidades_por_remito}"
      value_format_name: decimal_2
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Unidades por Remito"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 7
    col: 6
    width: 6
    height: 5
  - title: "Margen %"
    name: r_kpi_margenpct
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.margen_pct]
    hidden_fields: [fct_remitos.margen_pct]
    dynamic_fields:
    - table_calculation: rkpi_margenpct
      label: "Margen %"
      expression: "${fct_remitos.margen_pct}"
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Margen %"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 7
    col: 12
    width: 6
    height: 5
  - title: "Margen $"
    name: r_kpi_margen
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.margen_pesos]
    hidden_fields: [fct_remitos.margen_pesos]
    dynamic_fields:
    - table_calculation: rkpi_margen
      label: "Margen $"
      expression: "${fct_remitos.margen_pesos}"
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    show_single_value_title: true
    single_value_title: "Margen $"
    listen: { fecha: dim_fecha.fecha_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 7
    col: 18
    width: 6
    height: 5

  # ---------------- Tendencias diarias (area) ----------------
  - title: "Venta Remitos por dia"
    name: r_trend_venta
    model: lakehouse
    explore: fct_remitos
    type: looker_area
    fields: [dim_fecha.fecha_date, fct_remitos.venta_remito]
    sorts: [dim_fecha.fecha_date]
    listen: { fecha: dim_fecha.fecha_date, anio: dim_fecha.anio_sel, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 12
    col: 0
    width: 24
    height: 8

  - title: "Remitos por dia"
    name: r_trend_remitos
    model: lakehouse
    explore: fct_remitos
    type: looker_area
    fields: [dim_fecha.fecha_date, fct_remitos.remitos]
    sorts: [dim_fecha.fecha_date]
    listen: { fecha: dim_fecha.fecha_date, anio: dim_fecha.anio_sel, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 20
    col: 0
    width: 12
    height: 7
  - title: "Unidades Remitos por dia"
    name: r_trend_unidades
    model: lakehouse
    explore: fct_remitos
    type: looker_area
    fields: [dim_fecha.fecha_date, fct_remitos.unidades_remito]
    sorts: [dim_fecha.fecha_date]
    listen: { fecha: dim_fecha.fecha_date, anio: dim_fecha.anio_sel, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 20
    col: 12
    width: 12
    height: 7

  # ---------------- Detalle por Tipo Dispensa ----------------
  - title: "Detalle por Tipo Dispensa"
    name: r_dispensa
    model: lakehouse
    explore: fct_remitos
    type: looker_grid
    fields: [fct_remitos.tipo_dispensa, fct_remitos.venta_remito, fct_remitos.pct_venta_total, fct_remitos.remitos, fct_remitos.pct_remitos_total, fct_remitos.unidades_remito, fct_remitos.pct_unidades_total]
    sorts: [fct_remitos.venta_remito desc]
    series_cell_visualizations: { fct_remitos.venta_remito: { is_active: true } }
    listen: { fecha: dim_fecha.fecha_date, anio: dim_fecha.anio_sel, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 27
    col: 0
    width: 24
    height: 9

  # ---------------- Top Productos ----------------
  - title: "Top Productos - Remitos"
    name: r_productos
    model: lakehouse
    explore: fct_remitos
    type: looker_grid
    fields: [dim_articulo.producto, fct_remitos.venta_remito, fct_remitos.unidades_remito]
    sorts: [fct_remitos.venta_remito desc]
    limit: 20
    series_cell_visualizations: { fct_remitos.venta_remito: { is_active: true } }
    listen: { fecha: dim_fecha.fecha_date, anio: dim_fecha.anio_sel, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 36
    col: 0
    width: 24
    height: 9
