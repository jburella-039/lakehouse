view: bt_stk_stockciclico {
  sql_table_name: `bss_oracle.BT_STK_STOCKCICLICO` ;;

  dimension: ds_stc_observaciones {
    type: string
    sql: ${TABLE}.DS_STC_OBSERVACIONES ;;
  }
  dimension: fc_stc_ajuste {
    type: number
    sql: ${TABLE}.FC_STC_AJUSTE ;;
  }
  dimension: fc_stc_costo {
    type: number
    sql: ${TABLE}.FC_STC_COSTO ;;
  }
  dimension: fc_stc_inicial {
    type: number
    sql: ${TABLE}.FC_STC_INICIAL ;;
  }
  dimension: fc_stc_tomado {
    type: number
    sql: ${TABLE}.FC_STC_TOMADO ;;
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
  dimension: id_art_hissubcategoria {
    type: number
    sql: ${TABLE}.ID_ART_HISSUBCATEGORIA ;;
  }
  dimension: id_esc_stockciclicoestado {
    type: number
    sql: ${TABLE}.ID_ESC_STOCKCICLICOESTADO ;;
  }
  dimension: id_etl_cargadatos {
    type: number
    sql: ${TABLE}.ID_ETL_CARGADATOS ;;
  }
  dimension: id_pro_hisproveedor {
    type: number
    sql: ${TABLE}.ID_PRO_HISPROVEEDOR ;;
  }
  dimension_group: id_stc_fechacierre {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_STC_FECHACIERRE ;;
  }
  dimension_group: id_stc_fechastock {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_STC_FECHASTOCK ;;
  }
  dimension: id_stc_nroajuste {
    type: number
    sql: ${TABLE}.ID_STC_NROAJUSTE ;;
  }
  dimension: id_stc_responsablecierre {
    type: number
    sql: ${TABLE}.ID_STC_RESPONSABLECIERRE ;;
  }
  dimension: id_stc_responsabletoma {
    type: number
    sql: ${TABLE}.ID_STC_RESPONSABLETOMA ;;
  }
  dimension: id_stk_stockciclico {
    type: number
    sql: ${TABLE}.ID_STK_STOCKCICLICO ;;
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
  dimension: id_tkt_tipocomprobante {
    type: number
    sql: ${TABLE}.ID_TKT_TIPOCOMPROBANTE ;;
  }
  measure: count {
    type: count
  }
}
