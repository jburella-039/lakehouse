# =============================================================================
# view: fct_remitos
# Hecho de remitos de farmacia (obra social / dispensa) - BSS Oracle.
# Fuente: lakehouse-dev-483619.bss_oracle.BT_VTA_FARMACIA (nombres fisicos crudos).
# Equivale a la tabla "Remito" del cubo SSAS (pagina "Farmacia" del Power BI).
#
# Reconciliacion marzo 2026 (es_venta + resta_stock):
#  - Venta Remitos  = SUM(FC_TKF_MONTOTOTAL)      (~99B vs captura 95.5B)
#  - Costo          = SUM(FC_TKF_COSTOFARMACIA)
#  - Margen %       = 35.6% (captura 35.18%) -> definicion confirmada por el margen.
#  - Remitos        = COUNT(DISTINCT sucursal-dia-nroremito) ~2.45M (captura 2.39M)
#  - Unidades       = SUM(FC_TKF_CANTIDAD)
#  El nivel absoluto queda ~3% por encima de la captura (mismo estado de slicers
#  que las otras 3 paginas); los ratios (margen %, remito promedio) cuadran.
# =============================================================================

view: fct_remitos {
  sql_table_name: `lakehouse-dev-483619.bss_oracle.BT_VTA_FARMACIA` ;;

  # ---------------------------------------------------------------------------
  # CLAVES
  # ---------------------------------------------------------------------------
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${id_sucursal},'-',${TABLE}.ID_SUC_CAJA,'-',${id_tipocomprobante},'-',
                ${TABLE}.ID_TKT_NROCOMPROBANTE,'-',${cd_sku},'-',
                FORMAT_TIMESTAMP('%Y%m%d', ${TABLE}.ID_TIE_DIA)) ;;
  }

  # Key de remito: sucursal + dia + nro de remito (COUNTROWS SUMMARIZE del DAX).
  dimension: remito_key {
    hidden: yes
    type: string
    sql: CONCAT(${id_sucursal},'-',
                FORMAT_TIMESTAMP('%Y%m%d', ${TABLE}.ID_TIE_DIA),'-',
                CAST(${TABLE}.ID_OOS_NROREMITO AS STRING)) ;;
  }

  # ---------------------------------------------------------------------------
  # DIMENSIONES - claves de join (a wirear en el explore)
  # ---------------------------------------------------------------------------
  dimension: id_sucursal        { type: number sql: ${TABLE}.ID_SUC_SUCURSAL ;;        label: "Sucursal (ID)" }
  dimension: id_tipocomprobante { type: number sql: ${TABLE}.ID_TKT_TIPOCOMPROBANTE ;; hidden: yes }
  dimension: cd_sku             { type: number sql: ${TABLE}.ID_ART_CUF ;;             label: "SKU (Articulo)" }
  dimension: id_obrasocial      { type: number sql: ${TABLE}.ID_OOS_OBRASOCIAL ;;      hidden: yes }

  # Jerarquia de producto historica directa en el hecho (HIS*).
  dimension: id_departamento { type: number sql: ${TABLE}.ID_ART_HISDEPARTAMENTO ;; hidden: yes }
  dimension: id_categoria    { type: number sql: ${TABLE}.ID_ART_HISCATEGORIA ;;    hidden: yes }
  dimension: id_subcategoria { type: number sql: ${TABLE}.ID_ART_HISSUBCATEGORIA ;; hidden: yes }
  dimension: id_marca        { type: number sql: ${TABLE}.ID_ART_HISMARCA ;;         hidden: yes }

  # ---------------------------------------------------------------------------
  # DIMENSIONES - dispensa / cobertura
  # ---------------------------------------------------------------------------
  # Tipo de dispensa (pivot de la pagina Farmacia): "Venta Libre", "Receta", etc.
  dimension: tipo_dispensa {
    type: string
    sql: ${TABLE}.DS_VTA_DISPENSA ;;
    label: "Tipo Dispensa"
  }

  dimension: nombre_medico { type: string sql: ${TABLE}.DS_VTA_NOMBREMEDICO ;; label: "Medico" hidden: yes }

  dimension: es_psicotropico {
    type: yesno
    sql: ${TABLE}.ID_VTA_PSICOTROPICO = 1 ;;
    label: "Psicotropico?"
  }

  dimension: es_receta_digital {
    type: yesno
    sql: ${TABLE}.ID_VTA_ESRECETADIGITAL = 1 ;;
    label: "Receta Digital?"
  }

  # ---------------------------------------------------------------------------
  # TIEMPO
  # ---------------------------------------------------------------------------
  dimension_group: dia {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.ID_TIE_DIA ;;
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
    sql: ${TABLE}.FC_TKF_MONTOTOTAL ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes"]
    value_format_name: usd_0
    label: "Venta Remitos $"
  }

  measure: unidades_remito {
    type: sum
    sql: ${TABLE}.FC_TKF_CANTIDAD ;;
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
    sql: ${TABLE}.FC_TKF_COSTOFARMACIA ;;
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
  dimension: en_periodo {
    hidden: yes
    type: yesno
    sql: {% condition filtro_fecha %} DATE(${TABLE}.ID_TIE_DIA) {% endcondition %} ;;
  }
  dimension: en_periodo_aa {
    hidden: yes
    type: yesno
    sql: {% condition filtro_fecha %} DATE_ADD(DATE(${TABLE}.ID_TIE_DIA), INTERVAL 1 YEAR) {% endcondition %} ;;
  }

  measure: venta_periodo {
    type: sum
    sql: ${TABLE}.FC_TKF_MONTOTOTAL ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo: "yes"]
    value_format_name: usd_0
    label: "Venta Remitos $ (periodo)"
  }
  measure: venta_periodo_aa {
    type: sum
    sql: ${TABLE}.FC_TKF_MONTOTOTAL ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo_aa: "yes"]
    value_format_name: usd_0
    label: "Venta Remitos $ (periodo año ant.)"
  }

  measure: remitos_periodo {
    type: count_distinct
    sql: ${remito_key} ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo: "yes"]
    value_format_name: decimal_0
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
    sql: ${TABLE}.FC_TKF_CANTIDAD ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo: "yes"]
    value_format_name: decimal_0
    label: "Unidades Remitos (periodo)"
  }
  measure: unidades_periodo_aa {
    type: sum
    sql: ${TABLE}.FC_TKF_CANTIDAD ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo_aa: "yes"]
    value_format_name: decimal_0
    label: "Unidades Remitos (periodo año ant.)"
  }

  measure: costo_periodo {
    type: sum
    sql: ${TABLE}.FC_TKF_COSTOFARMACIA ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo: "yes"]
    value_format_name: usd_0
    label: "Costo Farmacia $ (periodo)"
  }
  measure: costo_periodo_aa {
    type: sum
    sql: ${TABLE}.FC_TKF_COSTOFARMACIA ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes", en_periodo_aa: "yes"]
    value_format_name: usd_0
    label: "Costo Farmacia $ (periodo año ant.)"
  }

  # Derivadas del periodo (margen y ratios), actual y año anterior.
  measure: margen_periodo {
    type: number
    sql: ${venta_periodo} - ${costo_periodo} ;;
    value_format_name: usd_0
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
}
