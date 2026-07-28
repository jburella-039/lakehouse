# =============================================================================
# TRD view: fct_stock  (capa semantica / metricas)
# Extiende raw_fct_stock y define las medidas de Stock (todos los dias y "ultimo
# dia" = StockDia). mto_costo / mto_preciopublico son UNITARIOS -> valorizado =
# cantidad * precio.
# =============================================================================

include: "/views_raw/bss_comercial/raw_fct_stock.view.lkml"

view: fct_stock {
  extends: [raw_fct_stock]
  label: "Comercial - Stock"

  # ---------------------------------------------------------------------------
  # DIMENSIONES expuestas al usuario (definidas en la capa raw)
  # ---------------------------------------------------------------------------
  dimension: id_sucursal       { hidden: no }
  dimension: cd_sku            { hidden: no }
  dimension: id_proveedor      { hidden: no }
  dimension_group: dia         { hidden: no }
  dimension: es_ultimo_dia     { hidden: no }
  dimension: pertenece_surtido { hidden: no }

  # ---------------------------------------------------------------------------
  # MEASURES - stock (todos los dias del periodo)
  # ---------------------------------------------------------------------------
  measure: unidades_disponibles {
    type: sum
    sql: ${TABLE}.FC_STK_CANTIDADDISPONIBLE ;;
    value_format_name: decimal_0
    label: "Unidades en Stock"
  }
  measure: stock_valorizado_costo {
    type: sum
    sql: ${TABLE}.FC_STK_CANTIDADDISPONIBLE * ${TABLE}.FC_STK_COSTO ;;
    value_format_name: usd_0
    label: "Stock Valorizado (costo)"
  }
  measure: stock_valorizado_pvp {
    type: sum
    sql: ${TABLE}.FC_STK_CANTIDADDISPONIBLE * ${TABLE}.FC_STK_PRECIOPUBLICO ;;
    value_format_name: usd_0
    label: "Stock Valorizado (PVP)"
  }
  measure: skus_con_stock {
    type: count_distinct
    sql: ${cd_sku} ;;
    label: "SKUs con Stock"
  }

  # ---------------------------------------------------------------------------
  # MEASURES - "ultimo dia" (equivalente a StockDia)
  # ---------------------------------------------------------------------------
  measure: unidades_ultimo_dia {
    type: sum
    sql: ${TABLE}.FC_STK_CANTIDADDISPONIBLE ;;
    filters: [es_ultimo_dia: "yes"]
    value_format_name: decimal_0
    label: "Unidades en Stock (ultimo dia)"
  }
  measure: stock_valorizado_costo_ultimo_dia {
    type: sum
    sql: ${TABLE}.FC_STK_CANTIDADDISPONIBLE * ${TABLE}.FC_STK_COSTO ;;
    filters: [es_ultimo_dia: "yes"]
    value_format_name: usd_0
    label: "Stock Valorizado costo (ultimo dia)"
  }
  measure: skus_con_stock_ultimo_dia {
    type: count_distinct
    sql: ${cd_sku} ;;
    filters: [es_ultimo_dia: "yes"]
    label: "SKUs con Stock (ultimo dia)"
  }
}
