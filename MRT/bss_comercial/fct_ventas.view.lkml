# =============================================================================
# TRD view: fct_ventas  (capa semantica / metricas)
# Extiende raw_fct_ventas (dimensiones + claves) y define TODAS las medidas de
# Ventas / Unidades / Tickets, incluyendo las dinamicas por periodo y las YoY.
# Alineado al MAPEO_SSAS_a_LookML v5.
#  - Venta neta s/IVA antes de desc = mto_totalsinivaantesdescuento.
#  - Unidades = cnt_unidades ; Costo = mto_costo ; Margen $ = neto - costo.
#  - Filtros por flags ESVENTA / RESTASTOCK via join a dim_tipocomprobante.
# =============================================================================

include: "/FND/bss_comercial/raw_fct_ventas.view.lkml"

view: fct_ventas {
  extends: [raw_fct_ventas]
  label: "Comercial - Ventas"

  # ---------------------------------------------------------------------------
  # DIMENSIONES expuestas al usuario (definidas en la capa raw)
  # ---------------------------------------------------------------------------
  dimension: id_sucursal        { hidden: no }
  dimension: id_caja            { hidden: no }
  dimension: id_tipocomprobante { hidden: no }
  dimension: cd_nrocomprobante  { hidden: no }
  dimension: cd_sku             { hidden: no }
  dimension: hk_vta_venta       { hidden: yes }
  dimension: id_obrasocial      { hidden: no }
  dimension: id_proveedor       { hidden: no }
  dimension: id_departamento    { hidden: no }
  dimension: id_categoria       { hidden: no }
  dimension: id_subcategoria    { hidden: no }
  dimension: id_marca           { hidden: no }
  dimension: id_cliente         { hidden: no }
  dimension: cliente_identificado { hidden: no }
  dimension: tipo_cobertura     { hidden: no }
  dimension_group: venta        { hidden: no }
  dimension_group: dia          { hidden: no }
  dimension: anio_sel           { hidden: no }
  dimension: num_hora           { hidden: no }

  # ---------------------------------------------------------------------------
  # MEASURES - base (Ventas / Unidades / Tickets)
  # ---------------------------------------------------------------------------
  # [Vta $ T SIva Ant Desc] - filtra ESVENTA=1 via join a dim_tipocomprobante
  measure: venta_neta {
    type: sum
    sql: ${TABLE}.mto_totalsinivaantesdescuento ;;
    filters: [dim_tipocomprobante.es_venta: "yes"]
    value_format_name: usd_0
    label: "Ventas"
    drill_fields: [detalle*]
  }

  # [Vta # T Unid Vend] - ESVENTA=1
  measure: unidades {
    type: sum
    sql: ${TABLE}.cnt_unidades ;;
    filters: [dim_tipocomprobante.es_venta: "yes"]
    value_format_name: decimal_0
    label: "Unidades"
  }

  # [Vta # Cant Tickets (Resta Stock)] - RESTASTOCK=1 & ESVENTA=1
  # COUNT(DISTINCT hk_vta_venta): hash key INT64 precomputado (ver PDT + BigQuery).
  measure: tickets {
    type: count_distinct
    sql: ${hk_vta_venta} ;;
    filters: [dim_tipocomprobante.resta_stock: "yes", dim_tipocomprobante.es_venta: "yes"]
    label: "Tickets"
  }

  measure: costo {
    type: sum
    sql: ${TABLE}.mto_costo ;;
    filters: [dim_tipocomprobante.es_venta: "yes"]
    value_format_name: usd_0
    label: "Costo $"
  }

  # ---------------------------------------------------------------------------
  # MEASURES - derivadas (margen y promedios)
  # ---------------------------------------------------------------------------
  measure: margen_pesos {
    type: number
    sql: ${venta_neta} - ${costo} ;;
    value_format_name: usd_0
    label: "Margen $ (s/IVA a/desc)"
  }
  measure: margen_pct {
    type: number
    sql: SAFE_DIVIDE(${venta_neta} - ${costo}, NULLIF(${venta_neta},0)) ;;
    value_format_name: percent_2
    label: "Margen %"
  }
  measure: ticket_promedio {
    type: number
    sql: SAFE_DIVIDE(${venta_neta}, NULLIF(${tickets},0)) ;;
    value_format_name: usd_0
    label: "Ticket Promedio"
  }
  measure: unidades_por_ticket {
    type: number
    sql: SAFE_DIVIDE(${unidades}, NULLIF(${tickets},0)) ;;
    value_format_name: decimal_2
    label: "Unidades por Ticket"
  }

  # Participacion sobre el total del contexto.
  measure: pct_venta_total {
    type: percent_of_total
    sql: ${venta_neta} ;;
    label: "% Venta (participacion)"
  }
  measure: pct_tickets_total {
    type: percent_of_total
    sql: ${tickets} ;;
    label: "% Tickets (participacion)"
  }
  measure: pct_unidades_total {
    type: percent_of_total
    sql: ${unidades} ;;
    label: "% Unidades (participacion)"
  }

  # ---------------------------------------------------------------------------
  # MEASURES dinamicas por periodo (KPIs que responden al filtro Fecha)
  # El filtro Fecha del dashboard se mapea (listen) a filtro_fecha. La version
  # "_aa" aplica el MISMO rango sobre la fecha + 1 año (DATE_ADD): comparacion
  # interanual dinamica (validada en BigQuery: marzo 26 vs 25 = +34.1%).
  # ---------------------------------------------------------------------------
  filter: filtro_fecha {
    type: date
    label: "Fecha (periodo KPI)"
  }

  # Patron Looker (timeframe vs timeframe): {% condition %} en una dimension yesno
  # y las medidas se filtran por ella. filtro_fecha (type: date) genera literales
  # TIMESTAMP; el lado izquierdo se normaliza a TIMESTAMP(DATE(fec_dia)).
  dimension: en_periodo {
    hidden: yes
    type: yesno
    sql: {% condition filtro_fecha %} TIMESTAMP(DATE(${TABLE}.fec_dia)) {% endcondition %} ;;
  }
  dimension: en_periodo_aa {
    hidden: yes
    type: yesno
    sql: {% condition filtro_fecha %} TIMESTAMP(DATE_ADD(DATE(${TABLE}.fec_dia), INTERVAL 1 YEAR)) {% endcondition %} ;;
  }
  # Union del periodo y su equivalente del año anterior. Filtro duro para acotar el scan.
  dimension: en_periodo_o_aa {
    hidden: yes
    type: yesno
    sql: ({% condition filtro_fecha %} TIMESTAMP(DATE(${TABLE}.fec_dia)) {% endcondition %})
      OR ({% condition filtro_fecha %} TIMESTAMP(DATE_ADD(DATE(${TABLE}.fec_dia), INTERVAL 1 YEAR)) {% endcondition %}) ;;
  }

  measure: venta_periodo {
    type: sum
    sql: ${TABLE}.mto_totalsinivaantesdescuento ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo: "yes"]
    value_format: "$#,##0.0,,,\"B\""
    label: "Venta $ (periodo)"
  }
  measure: venta_periodo_aa {
    type: sum
    sql: ${TABLE}.mto_totalsinivaantesdescuento ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo_aa: "yes"]
    value_format_name: usd_0
    label: "Venta $ (periodo año ant.)"
  }

  measure: tickets_periodo {
    type: count_distinct
    sql: ${hk_vta_venta} ;;
    filters: [dim_tipocomprobante.resta_stock: "yes", dim_tipocomprobante.es_venta: "yes", en_periodo: "yes"]
    value_format: "#,##0.0,,\"M\""
    label: "Tickets (periodo)"
  }
  measure: tickets_periodo_aa {
    type: count_distinct
    sql: ${hk_vta_venta} ;;
    filters: [dim_tipocomprobante.resta_stock: "yes", dim_tipocomprobante.es_venta: "yes", en_periodo_aa: "yes"]
    label: "Tickets (periodo año ant.)"
  }

  measure: unidades_periodo {
    type: sum
    sql: ${TABLE}.cnt_unidades ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo: "yes"]
    value_format: "#,##0.0,,\"M\""
    label: "Unidades (periodo)"
  }
  measure: unidades_periodo_aa {
    type: sum
    sql: ${TABLE}.cnt_unidades ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo_aa: "yes"]
    value_format_name: decimal_0
    label: "Unidades (periodo año ant.)"
  }

  measure: costo_periodo {
    type: sum
    sql: ${TABLE}.mto_costo ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo: "yes"]
    value_format_name: usd_0
    label: "Costo $ (periodo)"
  }
  measure: costo_periodo_aa {
    type: sum
    sql: ${TABLE}.mto_costo ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo_aa: "yes"]
    value_format_name: usd_0
    label: "Costo $ (periodo año ant.)"
  }

  # Derivadas del periodo (margen y ratios), actual y año anterior.
  measure: margen_periodo {
    type: number
    sql: ${venta_periodo} - ${costo_periodo} ;;
    value_format: "$#,##0.0,,,\"B\""
    label: "Margen $ (periodo)"
  }
  measure: margen_periodo_aa {
    type: number
    sql: ${venta_periodo_aa} - ${costo_periodo_aa} ;;
    value_format_name: usd_0
    label: "Margen $ (periodo año ant.)"
  }
  measure: margen_pct_periodo {
    type: number
    sql: SAFE_DIVIDE(${venta_periodo} - ${costo_periodo}, NULLIF(${venta_periodo},0)) ;;
    value_format_name: percent_2
    label: "Margen % (periodo)"
  }
  measure: margen_pct_periodo_aa {
    type: number
    sql: SAFE_DIVIDE(${venta_periodo_aa} - ${costo_periodo_aa}, NULLIF(${venta_periodo_aa},0)) ;;
    value_format_name: percent_2
    label: "Margen % (periodo año ant.)"
  }
  measure: ticket_promedio_periodo {
    type: number
    sql: SAFE_DIVIDE(${venta_periodo}, NULLIF(${tickets_periodo},0)) ;;
    value_format_name: usd_0
    label: "Ticket Promedio (periodo)"
  }
  measure: ticket_promedio_periodo_aa {
    type: number
    sql: SAFE_DIVIDE(${venta_periodo_aa}, NULLIF(${tickets_periodo_aa},0)) ;;
    value_format_name: usd_0
    label: "Ticket Promedio (periodo año ant.)"
  }
  measure: unidades_por_ticket_periodo {
    type: number
    sql: SAFE_DIVIDE(${unidades_periodo}, NULLIF(${tickets_periodo},0)) ;;
    value_format_name: decimal_2
    label: "Unidades por Ticket (periodo)"
  }
  measure: unidades_por_ticket_periodo_aa {
    type: number
    sql: SAFE_DIVIDE(${unidades_periodo_aa}, NULLIF(${tickets_periodo_aa},0)) ;;
    value_format_name: decimal_2
    label: "Unidades por Ticket (periodo año ant.)"
  }

  # ---------------------------------------------------------------------------
  # MEASURES YoY (% de variacion vs mismo periodo del año anterior)
  # Se usan como campo de comparacion en las tarjetas KPI (comparison_type: change).
  # Margen %: variacion en PUNTOS porcentuales (diferencia), no relativa.
  # ---------------------------------------------------------------------------
  measure: venta_yoy {
    type: number
    sql: SAFE_DIVIDE(${venta_periodo} - ${venta_periodo_aa}, NULLIF(${venta_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Ventas Var % (YoY)"
  }
  measure: tickets_yoy {
    type: number
    sql: SAFE_DIVIDE(${tickets_periodo} - ${tickets_periodo_aa}, NULLIF(${tickets_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Tickets Var % (YoY)"
  }
  measure: unidades_yoy {
    type: number
    sql: SAFE_DIVIDE(${unidades_periodo} - ${unidades_periodo_aa}, NULLIF(${unidades_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Unidades Var % (YoY)"
  }
  measure: ticket_promedio_yoy {
    type: number
    sql: SAFE_DIVIDE(${ticket_promedio_periodo} - ${ticket_promedio_periodo_aa}, NULLIF(${ticket_promedio_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Ticket Promedio Var % (YoY)"
  }
  measure: unidades_por_ticket_yoy {
    type: number
    sql: SAFE_DIVIDE(${unidades_por_ticket_periodo} - ${unidades_por_ticket_periodo_aa}, NULLIF(${unidades_por_ticket_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Unidades por Ticket Var % (YoY)"
  }
  measure: margen_yoy {
    type: number
    sql: SAFE_DIVIDE(${margen_periodo} - ${margen_periodo_aa}, NULLIF(${margen_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Margen $ Var % (YoY)"
  }
  # Margen %: diferencia en puntos porcentuales (x100 para mostrar "pp").
  measure: margen_pct_yoy {
    type: number
    sql: (${margen_pct_periodo} - ${margen_pct_periodo_aa}) * 100 ;;
    value_format: "0.00\" pp\""
    label: "Margen % Var (pp YoY)"
  }

  set: detalle {
    fields: [venta_date, id_sucursal, cd_nrocomprobante, cd_sku,
             id_categoria, id_marca, tipo_cobertura, unidades, venta_neta, margen_pesos]
  }
}
