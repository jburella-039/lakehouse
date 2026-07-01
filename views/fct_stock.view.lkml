# =============================================================================
# view: fct_stock
# Hecho de stock diario (snapshot por sucursal + SKU + dia).
# Fuente: lakehouse-dev-483619.bss_comercial.fct_stock (~22M filas, 365 dias).
# Grano: fec_dia + id_sucursal + cd_sku.
#
# "Stock del ultimo dia" (lo que devuelve la vista vw_bt_stk_stock_dia / StockDia)
# se obtiene aca filtrando al ultimo fec_dia cargado: dimension es_ultimo_dia
# (yesno) o el filtro Fecha del dashboard. No hace falta una vista aparte: Looker
# resuelve StockDia sobre la propia fct. La vista diaria solo aporta frescura
# extra (lee en vivo de stockcierre) cuando la carga de la fct viene atrasada.
#
# mto_costo / mto_preciopublico son UNITARIOS -> valorizado = cantidad * precio.
# =============================================================================

view: fct_stock {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.fct_stock` ;;

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(FORMAT_DATETIME('%Y%m%d', ${TABLE}.fec_dia),'-',
                ${id_sucursal},'-',${cd_sku}) ;;
  }

  # ---------------------------------------------------------------------------
  # DIMENSIONES - claves de join (wiradas en el explore)
  # ---------------------------------------------------------------------------
  dimension: id_sucursal     { type: number sql: ${TABLE}.id_sucursal ;;     label: "Sucursal (ID)" }
  dimension: cd_sku          { type: number sql: ${TABLE}.cd_sku ;;          label: "SKU (Articulo)" }
  dimension: id_departamento { type: number sql: ${TABLE}.id_departamento ;; hidden: yes }
  dimension: id_categoria    { type: number sql: ${TABLE}.id_categoria ;;    hidden: yes }
  dimension: id_subcategoria { type: number sql: ${TABLE}.id_subcategoria ;; hidden: yes }
  dimension: id_marca        { type: number sql: ${TABLE}.id_marca ;;        hidden: yes }
  dimension: id_proveedor    { type: number sql: ${TABLE}.id_proveedor ;;    label: "Proveedor (ID)" }

  # ---------------------------------------------------------------------------
  # TIEMPO (fec_dia es DATETIME)
  # ---------------------------------------------------------------------------
  dimension_group: dia {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_dia ;;
    label: "Fecha Stock"
  }

  # "Stock del ultimo dia" = la fila cae en el maximo fec_dia cargado en la fct.
  # Equivale a la vista StockDia sin materializar nada aparte.
  dimension: es_ultimo_dia {
    type: yesno
    sql: DATE(${TABLE}.fec_dia) = (
           SELECT MAX(DATE(fec_dia))
           FROM `lakehouse-dev-483619.bss_comercial.fct_stock`
         ) ;;
    label: "Es ultimo dia?"
  }

  dimension: pertenece_surtido {
    type: yesno
    sql: ${TABLE}.flg_perteneceasurtido ;;
    label: "Pertenece a Surtido?"
  }

  # ---------------------------------------------------------------------------
  # MEASURES - stock (todos los dias del periodo)
  # ---------------------------------------------------------------------------
  measure: unidades_disponibles {
    type: sum
    sql: ${TABLE}.cnt_disponible ;;
    value_format_name: decimal_0
    label: "Unidades en Stock"
  }
  measure: stock_valorizado_costo {
    type: sum
    sql: ${TABLE}.cnt_disponible * ${TABLE}.mto_costo ;;
    value_format_name: usd_0
    label: "Stock Valorizado (costo)"
  }
  measure: stock_valorizado_pvp {
    type: sum
    sql: ${TABLE}.cnt_disponible * ${TABLE}.mto_preciopublico ;;
    value_format_name: usd_0
    label: "Stock Valorizado (PVP)"
  }
  measure: skus_con_stock {
    type: count_distinct
    sql: ${cd_sku} ;;
    label: "SKUs con Stock"
  }

  # ---------------------------------------------------------------------------
  # MEASURES - "ultimo dia" (equivalente a StockDia), reutilizables desde el explore
  # ---------------------------------------------------------------------------
  measure: unidades_ultimo_dia {
    type: sum
    sql: ${TABLE}.cnt_disponible ;;
    filters: [es_ultimo_dia: "yes"]
    value_format_name: decimal_0
    label: "Unidades en Stock (ultimo dia)"
  }
  measure: stock_valorizado_costo_ultimo_dia {
    type: sum
    sql: ${TABLE}.cnt_disponible * ${TABLE}.mto_costo ;;
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
