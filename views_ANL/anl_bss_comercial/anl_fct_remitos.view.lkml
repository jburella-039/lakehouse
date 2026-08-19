include: "/views_BAS/bas_bss_comercial/bas_fct_remitos.view.lkml"

view: anl_fct_remitos {
  extends: [bas_fct_remitos]
  label: "Remitos"

  derived_table: {
    sql:
      SELECT
        r.*,
        -- Venta neta estilo PBI: saca IVA y resta descuentos (empleado, forma pago, cupon, total desc empleado)
        (r.mto_total
          - IFNULL(r.mto_descuentoempleado,0)
          - IFNULL(r.mto_descuentofp,0)
          - IFNULL(r.mto_cupondescuento,0)
          - IFNULL(r.mto_totaldescuentoempleado,0)
        ) / IF(IFNULL(iva.pct_iva,0) = 0, 1, 1 + iva.pct_iva/100) AS mto_total_neto
      -- Propia + Controlada (excluye Franquicia): scope del reporte PBI
      FROM `lakehouse-dev-483619.bss_comercial.vw_fct_remitos` AS r
      JOIN `lakehouse-dev-483619.bss_sucursales.dim_sucursal` AS s
        ON r.id_sucursal = s.id_sucursal
      LEFT JOIN `lakehouse-dev-483619.bss_finanzas.dim_tipoiva` AS iva
        ON r.id_tipoiva = iva.id_tipoiva
      WHERE s.id_tiporelacion IN (1, 3)
      ;;
    datagroup_trigger: venta_integral_datagroup
    partition_keys: ["fec_dia"]
    cluster_keys: ["id_sucursal", "id_tipocomprobante"]
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${id_sucursal},'-',${TABLE}.id_caja,'-',${id_tipocomprobante},'-',
                ${TABLE}.cd_nrocomprobante,'-',${cd_sku},'-',
                FORMAT_DATE('%Y%m%d', ${TABLE}.fec_dia)) ;;
  }

  # Clave nativa de cabecera de remito (INT64, sin nulos). Reemplaza al hk_remito
  # que antes se armaba con FARM_FINGERPRINT(sucursal + dia + nro remito); es 1:1
  # exacto con esa clave y viene directo de la fuente (bss_oracle.fct_remitos).
  dimension: id_remito {
    hidden: yes
    type: number
    sql: ${TABLE}.id_remito ;;
  }

  dimension: id_sucursal { hidden: no  label: "Sucursal (ID)" }
  dimension: cd_sku      { hidden: no  label: "SKU (Articulo)" }

  dimension: tipo_dispensa {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_dispensa ;;
    label: "Tipo Dispensa"
  }

  dimension: nombre_medico {
    type: string
    sql: ${TABLE}.dsc_nombremedico ;;
    label: "Medico"
  }

  dimension: es_psicotropico {
    hidden: no
    type: yesno
    sql: ${TABLE}.flg_psicotropico = 1 ;;
    label: "Psicotropico?"
  }

  dimension: es_receta_digital {
    hidden: no
    type: yesno
    sql: ${TABLE}.flg_esrecetadigital = 1 ;;
    label: "Receta Digital?"
  }

  dimension_group: fec_dia { hidden: no  label: "Fecha" }

  dimension: anio_sel {
    hidden: no
    type: string
    sql: CAST(${fec_dia_year} AS STRING) ;;
    label: "Año"
    suggestions: ["2026", "2025", "2024"]
  }

  measure: venta_remito {
    hidden: no
    type: sum
    sql: ${TABLE}.mto_total_neto ;;
    filters: [dim_tipocomprobante.es_venta: "yes"]
    value_format_name: usd_0
    label: "Venta Remitos $"
  }

  # Control: venta bruta (mto_total con IVA, es_venta + resta_stock). Definicion previa a la paridad PBI.
  measure: venta_remito_bruto {
    hidden: yes
    type: sum
    sql: ${TABLE}.mto_total ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes"]
    value_format_name: usd_0
    label: "Venta Remitos $ (bruto control)"
  }

  measure: unidades_remito {
    hidden: no
    type: sum
    sql: ${TABLE}.cnt_unidades ;;
    filters: [dim_tipocomprobante.es_venta: "yes"]
    value_format_name: decimal_0
    label: "Unidades Remitos"
  }

  # Control: unidades con es_venta + resta_stock. Definicion previa a la paridad PBI.
  measure: unidades_remito_bruto {
    hidden: yes
    type: sum
    sql: ${TABLE}.cnt_unidades ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes"]
    value_format_name: decimal_0
    label: "Unidades Remitos (control)"
  }

  measure: remitos {
    hidden: no
    type: count_distinct
    sql: ${id_remito} ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes"]
    value_format_name: decimal_0
    label: "Remitos"
  }

  measure: costo_remito {
    hidden: no
    type: sum
    sql: ${TABLE}.mto_costofarmacia ;;
    filters: [dim_tipocomprobante.es_venta: "yes"]
    value_format_name: usd_0
    label: "Costo Farmacia $"
  }

  # Control: costo con es_venta + resta_stock. Definicion previa a la paridad PBI.
  measure: costo_remito_bruto {
    hidden: yes
    type: sum
    sql: ${TABLE}.mto_costofarmacia ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes"]
    value_format_name: usd_0
    label: "Costo Farmacia $ (control)"
  }

  measure: margen_pesos {
    hidden: no
    type: number
    sql: ${venta_remito} - ${costo_remito} ;;
    value_format_name: usd_0
    label: "Margen $ Remitos"
  }

  measure: margen_pct {
    hidden: no
    type: number
    sql: SAFE_DIVIDE(${venta_remito} - ${costo_remito}, NULLIF(${venta_remito},0)) ;;
    value_format_name: percent_2
    label: "Margen % Remitos"
  }

  measure: remito_promedio {
    hidden: no
    type: number
    sql: SAFE_DIVIDE(${venta_remito}, NULLIF(${remitos},0)) ;;
    value_format_name: usd_0
    label: "Remito Promedio"
  }

  measure: unidades_por_remito {
    hidden: no
    type: number
    sql: SAFE_DIVIDE(${unidades_remito}, NULLIF(${remitos},0)) ;;
    value_format_name: decimal_2
    label: "Unidades por Remito"
  }

  measure: pct_venta_total {
    hidden: no
    type: percent_of_total
    sql: ${venta_remito} ;;
    label: "% Venta Remitos (participacion)"
  }

  measure: pct_remitos_total {
    hidden: no
    type: percent_of_total
    sql: ${remitos} ;;
    label: "% Remitos (participacion)"
  }

  measure: pct_unidades_total {
    hidden: no
    type: percent_of_total
    sql: ${unidades_remito} ;;
    label: "% Unidades Remitos (participacion)"
  }

  filter: filtro_fecha {
    hidden: no
    type: date
    label: "Fecha (periodo KPI)"
  }

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
  dimension: en_periodo_o_aa {
    hidden: yes
    type: yesno
    sql: ({% condition filtro_fecha %} TIMESTAMP(${TABLE}.fec_dia) {% endcondition %})
      OR ({% condition filtro_fecha %} TIMESTAMP(DATE_ADD(${TABLE}.fec_dia, INTERVAL 1 YEAR)) {% endcondition %}) ;;
  }

  measure: venta_periodo {
    hidden: no
    type: sum
    sql: ${TABLE}.mto_total_neto ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo: "yes"]
    value_format: "$#,##0.0,,,\"B\""
    label: "Venta Remitos $ (periodo)"
  }
  measure: venta_periodo_aa {
    hidden: no
    type: sum
    sql: ${TABLE}.mto_total_neto ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo_aa: "yes"]
    value_format_name: usd_0
    label: "Venta Remitos $ (periodo año ant.)"
  }

  measure: remitos_periodo {
    hidden: no
    type: count_distinct
    sql: ${id_remito} ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo: "yes"]
    value_format: "#,##0.0,,\"M\""
    label: "Remitos (periodo)"
  }
  measure: remitos_periodo_aa {
    hidden: no
    type: count_distinct
    sql: ${id_remito} ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo_aa: "yes"]
    value_format_name: decimal_0
    label: "Remitos (periodo año ant.)"
  }

  measure: unidades_periodo {
    hidden: no
    type: sum
    sql: ${TABLE}.cnt_unidades ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo: "yes"]
    value_format: "#,##0.0,,\"M\""
    label: "Unidades Remitos (periodo)"
  }
  measure: unidades_periodo_aa {
    hidden: no
    type: sum
    sql: ${TABLE}.cnt_unidades ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo_aa: "yes"]
    value_format_name: decimal_0
    label: "Unidades Remitos (periodo año ant.)"
  }

  measure: costo_periodo {
    hidden: no
    type: sum
    sql: ${TABLE}.mto_costofarmacia ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo: "yes"]
    value_format_name: usd_0
    label: "Costo Farmacia $ (periodo)"
  }
  measure: costo_periodo_aa {
    hidden: no
    type: sum
    sql: ${TABLE}.mto_costofarmacia ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo_aa: "yes"]
    value_format_name: usd_0
    label: "Costo Farmacia $ (periodo año ant.)"
  }

  measure: margen_periodo {
    hidden: no
    type: number
    sql: ${venta_periodo} - ${costo_periodo} ;;
    value_format: "$#,##0.0,,,\"B\""
    label: "Margen $ Remitos (periodo)"
  }
  measure: margen_periodo_aa {
    hidden: no
    type: number
    sql: ${venta_periodo_aa} - ${costo_periodo_aa} ;;
    value_format_name: usd_0
    label: "Margen $ Remitos (periodo año ant.)"
  }
  measure: margen_pct_periodo {
    hidden: no
    type: number
    sql: SAFE_DIVIDE(${venta_periodo} - ${costo_periodo}, NULLIF(${venta_periodo},0)) ;;
    value_format_name: percent_2
    label: "Margen % Remitos (periodo)"
  }
  measure: margen_pct_periodo_aa {
    hidden: no
    type: number
    sql: SAFE_DIVIDE(${venta_periodo_aa} - ${costo_periodo_aa}, NULLIF(${venta_periodo_aa},0)) ;;
    value_format_name: percent_2
    label: "Margen % Remitos (periodo año ant.)"
  }
  measure: remito_promedio_periodo {
    hidden: no
    type: number
    sql: SAFE_DIVIDE(${venta_periodo}, NULLIF(${remitos_periodo},0)) ;;
    value_format_name: usd_0
    label: "Remito Promedio (periodo)"
  }
  measure: remito_promedio_periodo_aa {
    hidden: no
    type: number
    sql: SAFE_DIVIDE(${venta_periodo_aa}, NULLIF(${remitos_periodo_aa},0)) ;;
    value_format_name: usd_0
    label: "Remito Promedio (periodo año ant.)"
  }
  measure: unidades_por_remito_periodo {
    hidden: no
    type: number
    sql: SAFE_DIVIDE(${unidades_periodo}, NULLIF(${remitos_periodo},0)) ;;
    value_format_name: decimal_2
    label: "Unidades por Remito (periodo)"
  }
  measure: unidades_por_remito_periodo_aa {
    hidden: no
    type: number
    sql: SAFE_DIVIDE(${unidades_periodo_aa}, NULLIF(${remitos_periodo_aa},0)) ;;
    value_format_name: decimal_2
    label: "Unidades por Remito (periodo año ant.)"
  }

  measure: venta_yoy {
    hidden: no
    type: number
    sql: SAFE_DIVIDE(${venta_periodo} - ${venta_periodo_aa}, NULLIF(${venta_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Venta Remitos Var % (YoY)"
  }
  measure: remitos_yoy {
    hidden: no
    type: number
    sql: SAFE_DIVIDE(${remitos_periodo} - ${remitos_periodo_aa}, NULLIF(${remitos_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Remitos Var % (YoY)"
  }
  measure: unidades_yoy {
    hidden: no
    type: number
    sql: SAFE_DIVIDE(${unidades_periodo} - ${unidades_periodo_aa}, NULLIF(${unidades_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Unidades Remitos Var % (YoY)"
  }
  measure: remito_promedio_yoy {
    hidden: no
    type: number
    sql: SAFE_DIVIDE(${remito_promedio_periodo} - ${remito_promedio_periodo_aa}, NULLIF(${remito_promedio_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Remito Promedio Var % (YoY)"
  }
  measure: unidades_por_remito_yoy {
    hidden: no
    type: number
    sql: SAFE_DIVIDE(${unidades_por_remito_periodo} - ${unidades_por_remito_periodo_aa}, NULLIF(${unidades_por_remito_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Unidades por Remito Var % (YoY)"
  }
  measure: margen_yoy {
    hidden: no
    type: number
    sql: SAFE_DIVIDE(${margen_periodo} - ${margen_periodo_aa}, NULLIF(${margen_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Margen $ Remitos Var % (YoY)"
  }
  measure: margen_pct_yoy {
    hidden: no
    type: number
    sql: (${margen_pct_periodo} - ${margen_pct_periodo_aa}) * 100 ;;
    value_format: "0.00\" pp\""
    label: "Margen % Remitos Var (pp YoY)"
  }
}
