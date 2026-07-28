# =============================================================================
# TRD view: fct_remitos  (capa semantica / metricas)
# Extiende raw_fct_remitos y define TODAS las medidas de Remitos (venta, unidades,
# remitos, margen) + dinamicas por periodo + YoY. Filtran ESVENTA=1 & RESTASTOCK=1.
# NOTA fec_dia es DATE: en_periodo hace TIMESTAMP(fec_dia) directo (sin DATE()).
# =============================================================================

include: "/views_raw/raw_fct_remitos.view.lkml"

view: fct_remitos {
  extends: [raw_fct_remitos]
  label: "Comercial - Remitos"

  # ---------------------------------------------------------------------------
  # DIMENSIONES expuestas al usuario (definidas en la capa raw)
  # ---------------------------------------------------------------------------
  dimension: id_sucursal       { hidden: no }
  dimension: cd_sku            { hidden: no }
  dimension: tipo_dispensa     { hidden: no }
  dimension: es_psicotropico   { hidden: no }
  dimension: es_receta_digital { hidden: no }
  dimension_group: dia         { hidden: no }
  dimension: anio_sel          { hidden: no }

  # ---------------------------------------------------------------------------
  # MEASURES - base
  # ---------------------------------------------------------------------------
  measure: venta_remito {
    type: sum
    sql: ${TABLE}.mto_total ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes"]
    value_format_name: usd_0
    label: "Venta Remitos $"
  }
  measure: unidades_remito {
    type: sum
    sql: ${TABLE}.cnt_unidades ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes"]
    value_format_name: decimal_0
    label: "Unidades Remitos"
  }
  # [Vta # Cant Remitos (Resta Stock)] - distinct sucursal-dia-nroremito.
  measure: remitos {
    type: count_distinct
    sql: ${remito_key} ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes"]
    value_format_name: decimal_0
    label: "Remitos"
  }
  measure: costo_remito {
    type: sum
    sql: ${TABLE}.mto_costofarmacia ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes"]
    value_format_name: usd_0
    label: "Costo Farmacia $"
  }

  # ---------------------------------------------------------------------------
  # MEASURES - derivadas
  # ---------------------------------------------------------------------------
  measure: margen_pesos {
    type: number
    sql: ${venta_remito} - ${costo_remito} ;;
    value_format_name: usd_0
    label: "Margen $ Remitos"
  }
  measure: margen_pct {
    type: number
    sql: SAFE_DIVIDE(${venta_remito} - ${costo_remito}, NULLIF(${venta_remito},0)) ;;
    value_format_name: percent_2
    label: "Margen % Remitos"
  }
  measure: remito_promedio {
    type: number
    sql: SAFE_DIVIDE(${venta_remito}, NULLIF(${remitos},0)) ;;
    value_format_name: usd_0
    label: "Remito Promedio"
  }
  measure: unidades_por_remito {
    type: number
    sql: SAFE_DIVIDE(${unidades_remito}, NULLIF(${remitos},0)) ;;
    value_format_name: decimal_2
    label: "Unidades por Remito"
  }
  measure: pct_venta_total {
    type: percent_of_total
    sql: ${venta_remito} ;;
    label: "% Venta Remitos (participacion)"
  }
  measure: pct_remitos_total {
    type: percent_of_total
    sql: ${remitos} ;;
    label: "% Remitos (participacion)"
  }
  measure: pct_unidades_total {
    type: percent_of_total
    sql: ${unidades_remito} ;;
    label: "% Unidades Remitos (participacion)"
  }

  # ---------------------------------------------------------------------------
  # MEASURES dinamicas por periodo (KPIs que responden al filtro Fecha)
  # ---------------------------------------------------------------------------
  filter: filtro_fecha {
    type: date
    label: "Fecha (periodo KPI)"
  }

  # fec_dia ya es DATE -> TIMESTAMP(fec_dia) da midnight UTC (no se envuelve en DATE()).
  dimension: en_periodo {
    hidden: yes
    type: yesno
    sql: {% condition filtro_fecha %} TIMESTAMP(${TABLE}.fec_dia) {% endcondition %} ;;
  }
  dimension: en_periodo_aa {
    hidden: yes
    type: yesno
    sql: {% condition filtro_fecha %} TIMESTAMP(DATE_ADD(${TABLE}.fec_dia, INTERVAL 1 YEAR)) {% endcondition %} ;;
  }

  measure: venta_periodo {
    type: sum
    sql: ${TABLE}.mto_total ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo: "yes"]
    value_format: "$#,##0.0,,,\"B\""
    label: "Venta Remitos $ (periodo)"
  }
  measure: venta_periodo_aa {
    type: sum
    sql: ${TABLE}.mto_total ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo_aa: "yes"]
    value_format_name: usd_0
    label: "Venta Remitos $ (periodo año ant.)"
  }

  measure: remitos_periodo {
    type: count_distinct
    sql: ${remito_key} ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo: "yes"]
    value_format: "#,##0.0,,\"M\""
    label: "Remitos (periodo)"
  }
  measure: remitos_periodo_aa {
    type: count_distinct
    sql: ${remito_key} ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo_aa: "yes"]
    value_format_name: decimal_0
    label: "Remitos (periodo año ant.)"
  }

  measure: unidades_periodo {
    type: sum
    sql: ${TABLE}.cnt_unidades ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo: "yes"]
    value_format: "#,##0.0,,\"M\""
    label: "Unidades Remitos (periodo)"
  }
  measure: unidades_periodo_aa {
    type: sum
    sql: ${TABLE}.cnt_unidades ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo_aa: "yes"]
    value_format_name: decimal_0
    label: "Unidades Remitos (periodo año ant.)"
  }

  measure: costo_periodo {
    type: sum
    sql: ${TABLE}.mto_costofarmacia ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo: "yes"]
    value_format_name: usd_0
    label: "Costo Farmacia $ (periodo)"
  }
  measure: costo_periodo_aa {
    type: sum
    sql: ${TABLE}.mto_costofarmacia ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo_aa: "yes"]
    value_format_name: usd_0
    label: "Costo Farmacia $ (periodo año ant.)"
  }

  # Derivadas del periodo (margen y ratios), actual y año anterior.
  measure: margen_periodo {
    type: number
    sql: ${venta_periodo} - ${costo_periodo} ;;
    value_format: "$#,##0.0,,,\"B\""
    label: "Margen $ Remitos (periodo)"
  }
  measure: margen_periodo_aa {
    type: number
    sql: ${venta_periodo_aa} - ${costo_periodo_aa} ;;
    value_format_name: usd_0
    label: "Margen $ Remitos (periodo año ant.)"
  }
  measure: margen_pct_periodo {
    type: number
    sql: SAFE_DIVIDE(${venta_periodo} - ${costo_periodo}, NULLIF(${venta_periodo},0)) ;;
    value_format_name: percent_2
    label: "Margen % Remitos (periodo)"
  }
  measure: margen_pct_periodo_aa {
    type: number
    sql: SAFE_DIVIDE(${venta_periodo_aa} - ${costo_periodo_aa}, NULLIF(${venta_periodo_aa},0)) ;;
    value_format_name: percent_2
    label: "Margen % Remitos (periodo año ant.)"
  }
  measure: remito_promedio_periodo {
    type: number
    sql: SAFE_DIVIDE(${venta_periodo}, NULLIF(${remitos_periodo},0)) ;;
    value_format_name: usd_0
    label: "Remito Promedio (periodo)"
  }
  measure: remito_promedio_periodo_aa {
    type: number
    sql: SAFE_DIVIDE(${venta_periodo_aa}, NULLIF(${remitos_periodo_aa},0)) ;;
    value_format_name: usd_0
    label: "Remito Promedio (periodo año ant.)"
  }
  measure: unidades_por_remito_periodo {
    type: number
    sql: SAFE_DIVIDE(${unidades_periodo}, NULLIF(${remitos_periodo},0)) ;;
    value_format_name: decimal_2
    label: "Unidades por Remito (periodo)"
  }
  measure: unidades_por_remito_periodo_aa {
    type: number
    sql: SAFE_DIVIDE(${unidades_periodo_aa}, NULLIF(${remitos_periodo_aa},0)) ;;
    value_format_name: decimal_2
    label: "Unidades por Remito (periodo año ant.)"
  }

  # ---------------------------------------------------------------------------
  # MEASURES YoY (% de variacion vs mismo periodo del año anterior)
  # ---------------------------------------------------------------------------
  measure: venta_yoy {
    type: number
    sql: SAFE_DIVIDE(${venta_periodo} - ${venta_periodo_aa}, NULLIF(${venta_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Venta Remitos Var % (YoY)"
  }
  measure: remitos_yoy {
    type: number
    sql: SAFE_DIVIDE(${remitos_periodo} - ${remitos_periodo_aa}, NULLIF(${remitos_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Remitos Var % (YoY)"
  }
  measure: unidades_yoy {
    type: number
    sql: SAFE_DIVIDE(${unidades_periodo} - ${unidades_periodo_aa}, NULLIF(${unidades_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Unidades Remitos Var % (YoY)"
  }
  measure: remito_promedio_yoy {
    type: number
    sql: SAFE_DIVIDE(${remito_promedio_periodo} - ${remito_promedio_periodo_aa}, NULLIF(${remito_promedio_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Remito Promedio Var % (YoY)"
  }
  measure: unidades_por_remito_yoy {
    type: number
    sql: SAFE_DIVIDE(${unidades_por_remito_periodo} - ${unidades_por_remito_periodo_aa}, NULLIF(${unidades_por_remito_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Unidades por Remito Var % (YoY)"
  }
  measure: margen_yoy {
    type: number
    sql: SAFE_DIVIDE(${margen_periodo} - ${margen_periodo_aa}, NULLIF(${margen_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Margen $ Remitos Var % (YoY)"
  }
  # Margen %: diferencia en puntos porcentuales (x100 para mostrar "pp").
  measure: margen_pct_yoy {
    type: number
    sql: (${margen_pct_periodo} - ${margen_pct_periodo_aa}) * 100 ;;
    value_format: "0.00\" pp\""
    label: "Margen % Remitos Var (pp YoY)"
  }
}
