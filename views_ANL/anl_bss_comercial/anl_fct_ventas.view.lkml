include: "/views_BAS/bas_bss_comercial/bas_fct_ventas.view.lkml"

view: anl_fct_ventas {
  extends: [bas_fct_ventas]
  label: "Ventas"

  derived_table: {
    sql:
      SELECT f.*
      FROM `lakehouse-dev-483619.bss_comercial.vw_fct_ventas` AS f ;;
    datagroup_trigger: venta_integral_datagroup
    partition_keys: ["fec_dia"]
    cluster_keys: ["id_sucursal", "id_tipocomprobante", "cd_nrocomprobante"]
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${id_sucursal},'-',${id_caja},'-',${id_tipocomprobante},'-',
                ${cd_nrocomprobante},'-',${cd_sku}) ;;
  }

  dimension: id_venta {
    hidden: yes
    type: number
    sql: ${TABLE}.id_venta ;;
  }

  dimension: ticket_key {
    hidden: yes
    type: string
    sql: CAST(${id_venta} AS STRING) ;;
  }

  dimension: id_sucursal        { label: "Sucursal (ID)" }
  dimension: id_caja            { label: "Caja" }
  dimension: id_tipocomprobante { label: "Tipo Comprobante (ID)" }
  dimension: cd_nrocomprobante  { label: "Nro Comprobante" }
  dimension: cd_sku             { label: "SKU (Articulo)" }
  dimension: id_obrasocial      { label: "Obra Social (ID)" }
  dimension: id_proveedor       { label: "Proveedor (ID)" }
  dimension: id_departamento    { label: "Departamento (ID)" }
  dimension: id_categoria       { label: "Categoria (ID)" }
  dimension: id_subcategoria    { label: "Subcategoria (ID)" }
  dimension: id_marca           { label: "Marca (ID)" }
  dimension: id_cliente         { label: "Cliente (ID)" }
  dimension: num_hora           { label: "Hora del Dia" }

  dimension: cliente_identificado {
    type: yesno
    sql: ${TABLE}.id_cliente <> -1 AND ${TABLE}.id_cliente IS NOT NULL ;;
    label: "Cliente Identificado?"
  }

  dimension: tipo_cobertura {
    type: string
    sql: CASE WHEN ${TABLE}.id_obrasocial IS NULL OR ${TABLE}.id_obrasocial <= 0
              THEN 'Particular' ELSE 'Obra Social / Coseguro' END ;;
    label: "Tipo de Cobertura"
  }

  dimension_group: fec_venta { label: "Fecha de Venta" }
  dimension_group: fec_dia   { label: "Fecha" }

  dimension: anio_sel {
    type: string
    sql: CAST(${fec_dia_year} AS STRING) ;;
    label: "Año"
    suggestions: ["2026", "2025", "2024"]
  }

  measure: venta_neta {
    type: sum
    sql: ${TABLE}.mto_totalsinivaantesdescuento ;;
    filters: [dim_tipocomprobante.es_venta: "yes"]
    value_format_name: usd_0
    label: "Ventas"
    drill_fields: [detalle*]
  }

  measure: unidades {
    type: sum
    sql: ${TABLE}.cnt_unidades ;;
    filters: [dim_tipocomprobante.es_venta: "yes"]
    value_format_name: decimal_0
    label: "Unidades"
  }

  measure: tickets {
    type: count_distinct
    sql: ${id_venta} ;;
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

  filter: filtro_fecha {
    type: date
    label: "Fecha (periodo KPI)"
  }

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
    sql: ${id_venta} ;;
    filters: [dim_tipocomprobante.resta_stock: "yes", dim_tipocomprobante.es_venta: "yes", en_periodo: "yes"]
    value_format: "#,##0.0,,\"M\""
    label: "Tickets (periodo)"
  }
  measure: tickets_periodo_aa {
    type: count_distinct
    sql: ${id_venta} ;;
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
  measure: margen_pct_yoy {
    type: number
    sql: (${margen_pct_periodo} - ${margen_pct_periodo_aa}) * 100 ;;
    value_format: "0.00\" pp\""
    label: "Margen % Var (pp YoY)"
  }

  set: detalle {
    fields: [fec_venta_date, id_sucursal, cd_nrocomprobante, cd_sku,
             id_categoria, id_marca, tipo_cobertura, unidades, venta_neta, margen_pesos]
  }
}
