# =============================================================================
# Dashboard: Venta Integral - Remitos   (PBI: "Farmacia")
# Fuente: explore fct_remitos (BT_VTA_FARMACIA). Medidas de la tabla Remito.
#
# Reconciliacion marzo 2026 (ver fct_remitos.view): definiciones confirmadas por
# el cruce de margen; el nivel absoluto queda ~3% sobre la captura por estado de
# slicers (igual que las otras 3 paginas).
#
# No migrado: las variaciones interanuales ("2025: X%" de la captura). En SSAS son
# medidas MMAA (SAMEPERIODLASTYEAR). En Looker se resuelven con comparacion de
# periodo en el tile o precalculando MMAA en BigQuery.
# =============================================================================

- dashboard: venta_remitos
  title: "Venta Integral - Remitos"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Remitos de farmacia (obra social / dispensa): venta, remitos, unidades y margen."

  filters:
  - name: fecha
    title: "Fecha (dia contable)"
    type: field_filter
    default_value: "2026/03/01 to 2026/04/01"
    model: lakehouse
    explore: fct_remitos
    field: fct_remitos.dia_date
    allow_multiple_values: true
    required: false
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
  # ---------------- KPIs fila 1 ----------------
  - title: "Venta Remitos $"
    name: r_kpi_venta
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.venta_remito]
    listen: { fecha: fct_remitos.dia_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 0
    col: 0
    width: 8
    height: 3
  - title: "Remitos"
    name: r_kpi_remitos
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.remitos]
    listen: { fecha: fct_remitos.dia_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 0
    col: 8
    width: 8
    height: 3
  - title: "Unidades Remitos"
    name: r_kpi_unidades
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.unidades_remito]
    listen: { fecha: fct_remitos.dia_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 0
    col: 16
    width: 8
    height: 3

  # ---------------- KPIs fila 2 ----------------
  - title: "Remito Promedio"
    name: r_kpi_promedio
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.remito_promedio]
    listen: { fecha: fct_remitos.dia_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 3
    col: 0
    width: 6
    height: 3
  - title: "Unidades por Remito"
    name: r_kpi_uxr
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.unidades_por_remito]
    listen: { fecha: fct_remitos.dia_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 3
    col: 6
    width: 6
    height: 3
  - title: "Margen %"
    name: r_kpi_margenpct
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.margen_pct]
    listen: { fecha: fct_remitos.dia_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 3
    col: 12
    width: 6
    height: 3
  - title: "Margen $"
    name: r_kpi_margen
    model: lakehouse
    explore: fct_remitos
    type: single_value
    fields: [fct_remitos.margen_pesos]
    listen: { fecha: fct_remitos.dia_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 3
    col: 18
    width: 6
    height: 3

  # ---------------- Tendencias diarias (area) ----------------
  - title: "Venta Remitos por dia"
    name: r_trend_venta
    model: lakehouse
    explore: fct_remitos
    type: looker_area
    fields: [fct_remitos.dia_date, fct_remitos.venta_remito]
    sorts: [fct_remitos.dia_date]
    listen: { fecha: fct_remitos.dia_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 6
    col: 0
    width: 24
    height: 8

  - title: "Remitos por dia"
    name: r_trend_remitos
    model: lakehouse
    explore: fct_remitos
    type: looker_area
    fields: [fct_remitos.dia_date, fct_remitos.remitos]
    sorts: [fct_remitos.dia_date]
    listen: { fecha: fct_remitos.dia_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 14
    col: 0
    width: 12
    height: 7
  - title: "Unidades Remitos por dia"
    name: r_trend_unidades
    model: lakehouse
    explore: fct_remitos
    type: looker_area
    fields: [fct_remitos.dia_date, fct_remitos.unidades_remito]
    sorts: [fct_remitos.dia_date]
    listen: { fecha: fct_remitos.dia_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 14
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
    listen: { fecha: fct_remitos.dia_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 21
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
    listen: { fecha: fct_remitos.dia_date, formato: dim_formato.formato, dispensa: fct_remitos.tipo_dispensa, obrasocial: dim_obrasocial.obrasocial }
    row: 30
    col: 0
    width: 24
    height: 9
