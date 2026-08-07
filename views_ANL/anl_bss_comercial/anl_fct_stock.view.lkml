include: "/views_BAS/bas_bss_comercial/bas_fct_stock.view.lkml"

view: anl_fct_stock {
  extends: [bas_fct_stock]
  label: "Stock"

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(FORMAT_TIMESTAMP('%Y%m%d', ${TABLE}.ID_TIE_DIA),'-',
                ${id_sucursal},'-',${cd_sku}) ;;
  }

  dimension: id_sucursal {
    hidden: no
    type: number
    sql: ${TABLE}.ID_SUC_SUCURSAL ;;
    label: "Sucursal (ID)"
  }
  dimension: cd_sku {
    hidden: no
    type: number
    sql: ${TABLE}.ID_ART_CUF ;;
    label: "SKU (Articulo)"
  }
  dimension: id_proveedor {
    hidden: no
    type: number
    sql: ${TABLE}.ID_PRO_HISPROVEEDOR ;;
    label: "Proveedor (ID)"
  }

  dimension_group: dia {
    hidden: no
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.ID_TIE_DIA ;;
    label: "Fecha Stock"
  }

  dimension: es_ultimo_dia {
    hidden: no
    type: yesno
    sql: DATE(${TABLE}.ID_TIE_DIA) = (
           SELECT MAX(DATE(ID_TIE_DIA))
           FROM `lakehouse-dev-483619.bss_comercial.vw_fct_stock`
         ) ;;
    label: "Es ultimo dia?"
  }

  dimension: pertenece_surtido {
    hidden: no
    type: yesno
    sql: ${TABLE}.FL_STK_PERTENECEASURTIDO = 1 ;;
    label: "Pertenece a Surtido?"
  }

  measure: unidades_disponibles {
    hidden: no
    type: sum
    sql: ${TABLE}.FC_STK_CANTIDADDISPONIBLE ;;
    value_format_name: decimal_0
    label: "Unidades en Stock"
  }
  measure: stock_valorizado_costo {
    hidden: no
    type: sum
    sql: ${TABLE}.FC_STK_CANTIDADDISPONIBLE * ${TABLE}.FC_STK_COSTO ;;
    value_format_name: usd_0
    label: "Stock Valorizado (costo)"
  }
  measure: stock_valorizado_pvp {
    hidden: no
    type: sum
    sql: ${TABLE}.FC_STK_CANTIDADDISPONIBLE * ${TABLE}.FC_STK_PRECIOPUBLICO ;;
    value_format_name: usd_0
    label: "Stock Valorizado (PVP)"
  }
  measure: skus_con_stock {
    hidden: no
    type: count_distinct
    sql: ${cd_sku} ;;
    label: "SKUs con Stock"
  }

  measure: unidades_ultimo_dia {
    hidden: no
    type: sum
    sql: ${TABLE}.FC_STK_CANTIDADDISPONIBLE ;;
    filters: [es_ultimo_dia: "yes"]
    value_format_name: decimal_0
    label: "Unidades en Stock (ultimo dia)"
  }
  measure: stock_valorizado_costo_ultimo_dia {
    hidden: no
    type: sum
    sql: ${TABLE}.FC_STK_CANTIDADDISPONIBLE * ${TABLE}.FC_STK_COSTO ;;
    filters: [es_ultimo_dia: "yes"]
    value_format_name: usd_0
    label: "Stock Valorizado costo (ultimo dia)"
  }
  measure: skus_con_stock_ultimo_dia {
    hidden: no
    type: count_distinct
    sql: ${cd_sku} ;;
    filters: [es_ultimo_dia: "yes"]
    label: "SKUs con Stock (ultimo dia)"
  }
}
