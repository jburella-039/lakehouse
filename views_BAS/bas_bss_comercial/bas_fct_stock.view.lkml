view: bas_fct_stock {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.vw_fct_stock` ;;
  fields_hidden_by_default: yes

  dimension: fc_stk_cantidadasignada {
    type: number
    sql: ${TABLE}.FC_STK_CANTIDADASIGNADA ;;
  }
  dimension: fc_stk_cantidaddevolucion {
    type: number
    sql: ${TABLE}.FC_STK_CANTIDADDEVOLUCION ;;
  }
  dimension: fc_stk_cantidaddisponible {
    type: number
    sql: ${TABLE}.FC_STK_CANTIDADDISPONIBLE ;;
  }
  dimension: fc_stk_costo {
    type: number
    sql: ${TABLE}.FC_STK_COSTO ;;
  }
  dimension: fc_stk_costodevolucion {
    type: number
    sql: ${TABLE}.FC_STK_COSTODEVOLUCION ;;
  }
  dimension: fc_stk_preciopublico {
    type: number
    sql: ${TABLE}.FC_STK_PRECIOPUBLICO ;;
  }
  dimension: fl_stk_perteneceasurtido {
    type: number
    sql: ${TABLE}.FL_STK_PERTENECEASURTIDO ;;
  }
  dimension: id_art_cuf {
    type: number
    sql: ${TABLE}.ID_ART_CUF ;;
  }
  dimension: id_art_hiscategoria {
    type: number
    sql: ${TABLE}.ID_ART_HISCATEGORIA ;;
  }
  dimension: id_art_hisdepartamento {
    type: number
    sql: ${TABLE}.ID_ART_HISDEPARTAMENTO ;;
  }
  dimension: id_art_hismarca {
    type: number
    sql: ${TABLE}.ID_ART_HISMARCA ;;
  }
  dimension: id_art_hissubcategoria {
    type: number
    sql: ${TABLE}.ID_ART_HISSUBCATEGORIA ;;
  }
  dimension: id_etl_cargadatos {
    type: number
    sql: ${TABLE}.ID_ETL_CARGADATOS ;;
  }
  dimension: id_pro_hisproveedor {
    type: number
    sql: ${TABLE}.ID_PRO_HISPROVEEDOR ;;
  }
  dimension_group: id_stk_fechaalta {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_STK_FECHAALTA ;;
  }
  dimension_group: id_stk_fechaultimamodificacion {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_STK_FECHAULTIMAMODIFICACION ;;
  }
  dimension: id_stk_tiporotdemanda {
    type: number
    sql: ${TABLE}.ID_STK_TIPOROTDEMANDA ;;
  }
  dimension: id_stk_tiporotmargen {
    type: number
    sql: ${TABLE}.ID_STK_TIPOROTMARGEN ;;
  }
  dimension: id_stk_tiporotvolumen {
    type: number
    sql: ${TABLE}.ID_STK_TIPOROTVOLUMEN ;;
  }
  dimension: id_suc_sucursal {
    type: number
    sql: ${TABLE}.ID_SUC_SUCURSAL ;;
  }
  dimension_group: id_tie_dia {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_TIE_DIA ;;
  }
  dimension: id_tie_mes {
    type: number
    sql: ${TABLE}.ID_TIE_MES ;;
  }
  measure: count {
    type: count
  }
}
