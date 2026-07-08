# =============================================================================
# view: fct_remitos
# Hecho de remitos de farmacia (obra social / dispensa) - BSS Comercial.
# Fuente: lakehouse-dev-483619.bss_comercial.vw_fct_remitos (nombres logicos).
# Reemplaza a bss_oracle.BT_VTA_FARMACIA (nombres fisicos crudos). Validado 1:1
# en marzo 2026: venta, unidades, costo, remitos y filas coinciden exacto.
# Equivale a la tabla "Remito" del cubo SSAS (pagina "Farmacia" del Power BI).
#
# Mapeo de columnas crudo -> vista comercial (las que consume este view):
#  ID_SUC_SUCURSAL->id_sucursal, ID_SUC_CAJA->id_caja,
#  ID_TKT_TIPOCOMPROBANTE->id_tipocomprobante, ID_TKT_NROCOMPROBANTE->cd_nrocomprobante,
#  ID_ART_CUF->cd_sku, ID_OOS_OBRASOCIAL->id_obrasocial, ID_OOS_NROREMITO->id_nroremito,
#  ID_ART_HISDEPARTAMENTO->id_departamento, ID_ART_HISCATEGORIA->id_categoria,
#  ID_ART_HISSUBCATEGORIA->id_subcategoria, ID_ART_HISMARCA->id_marca,
#  DS_VTA_DISPENSA->dsc_dispensa, DS_VTA_NOMBREMEDICO->dsc_nombremedico,
#  ID_VTA_PSICOTROPICO->flg_psicotropico, ID_VTA_ESRECETADIGITAL->flg_esrecetadigital,
#  ID_TIE_DIA->fec_dia (ahora DATE, antes TIMESTAMP), FC_TKF_MONTOTOTAL->mto_total,
#  FC_TKF_CANTIDAD->cnt_unidades, FC_TKF_COSTOFARMACIA->mto_costofarmacia.
# NOTA fec_dia es DATE: pk/remito_key usan FORMAT_DATE (no FORMAT_TIMESTAMP) y
# en_periodo hace TIMESTAMP(fec_dia) directo (sin DATE(), que no acepta un DATE).
# =============================================================================

view: fct_remitos {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.vw_fct_remitos` ;;

  # ---------------------------------------------------------------------------
  # CLAVES
  # ---------------------------------------------------------------------------
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${id_sucursal},'-',${TABLE}.id_caja,'-',${id_tipocomprobante},'-',
                ${TABLE}.cd_nrocomprobante,'-',${cd_sku},'-',
                FORMAT_DATE('%Y%m%d', ${TABLE}.fec_dia)) ;;
  }

  # Key de remito: sucursal + dia + nro de remito (COUNTROWS SUMMARIZE del DAX).
  dimension: remito_key {
    hidden: yes
    type: string
    sql: CONCAT(${id_sucursal},'-',
                FORMAT_DATE('%Y%m%d', ${TABLE}.fec_dia),'-',
                CAST(${TABLE}.id_nroremito AS STRING)) ;;
  }

  # ---------------------------------------------------------------------------
  # DIMENSIONES - claves de join (a wirear en el explore)
  # ---------------------------------------------------------------------------
  dimension: id_sucursal        { type: number sql: ${TABLE}.id_sucursal ;;        label: "Sucursal (ID)" }
  dimension: id_tipocomprobante { type: number sql: ${TABLE}.id_tipocomprobante ;; hidden: yes }
  dimension: cd_sku             { type: number sql: ${TABLE}.cd_sku ;;             label: "SKU (Articulo)" }
  dimension: id_obrasocial      { type: number sql: ${TABLE}.id_obrasocial ;;      hidden: yes }

  # Jerarquia de producto historica directa en el hecho.
  dimension: id_departamento { type: number sql: ${TABLE}.id_departamento ;; hidden: yes }
  dimension: id_categoria    { type: number sql: ${TABLE}.id_categoria ;;    hidden: yes }
  dimension: id_subcategoria { type: number sql: ${TABLE}.id_subcategoria ;; hidden: yes }
  dimension: id_marca        { type: number sql: ${TABLE}.id_marca ;;         hidden: yes }

  # ---------------------------------------------------------------------------
  # DIMENSIONES - dispensa / cobertura
  # ---------------------------------------------------------------------------
  # Tipo de dispensa (pivot de la pagina Farmacia): "Venta Libre", "Receta", etc.
  dimension: tipo_dispensa {
    type: string
    sql: ${TABLE}.dsc_dispensa ;;
    label: "Tipo Dispensa"
  }

  dimension: nombre_medico { type: string sql: ${TABLE}.dsc_nombremedico ;; label: "Medico" hidden: yes }

  dimension: es_psicotropico {
    type: yesno
    sql: ${TABLE}.flg_psicotropico = 1 ;;
    label: "Psicotropico?"
  }

  dimension: es_receta_digital {
    type: yesno
    sql: ${TABLE}.flg_esrecetadigital = 1 ;;
    label: "Receta Digital?"
  }

  # ---------------------------------------------------------------------------
  # TIEMPO
  # ---------------------------------------------------------------------------
  dimension_group: dia {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_dia ;;
    label: "Fecha"
  }

  # Año como STRING para el filtro selector (dropdown). Ver nota en fct_ventas.
  dimension: anio_sel {
    type: string
    sql: CAST(${dia_year} AS STRING) ;;
    label: "Año"
    suggestions: ["2026", "2025", "2024"]
  }

  # ---------------------------------------------------------------------------
  # MEASURES - base
  # ---------------------------------------------------------------------------
  # [Vta $ ... Remitos] - monto total; filtra ESVENTA=1 & RESTASTOCK=1.
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

  # [% Vta $ T SIva Ant Desc Remitos]
  measure: pct_venta_total {
    type: percent_of_total
    sql: ${venta_remito} ;;
    label: "% Venta Remitos (participacion)"
  }

  # [% Vta # Cant Remitos (Resta Stock)]
  measure: pct_remitos_total {
    type: percent_of_total
    sql: ${remitos} ;;
    label: "% Remitos (participacion)"
  }

  # [% Vta # T Unid Vend Remitos]
  measure: pct_unidades_total {
    type: percent_of_total
    sql: ${unidades_remito} ;;
    label: "% Unidades Remitos (participacion)"
  }

  # ---------------------------------------------------------------------------
  # MEASURES dinamicas por periodo (KPIs que responden al filtro Fecha)
  # Mismo patron que fct_ventas: filtro_fecha via listen; "_aa" aplica el rango
  # sobre el dia + 1 año (DATE_ADD) para el mismo periodo del año anterior.
  # ---------------------------------------------------------------------------
  filter: filtro_fecha {
    type: date
    label: "Fecha (periodo KPI)"
  }

  # Patron documentado por Looker (timeframe vs timeframe): {% condition %} en una
  # dimension yesno y las medidas se filtran por ella (no dentro del sql de la medida).
  # filtro_fecha (filter type: date) genera literales TIMESTAMP; el lado izquierdo
  # debe ser TIMESTAMP. fec_dia ya es DATE, asi que TIMESTAMP(fec_dia) da midnight UTC
  # (no se envuelve en DATE(), que no acepta un DATE). Ver nota en fct_ventas.
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
  # MEASURES YoY (% de variacion vs mismo periodo del año anterior). Ver nota en
  # fct_ventas. Se usan como campo de comparacion en las tarjetas KPI.
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
