view: bt_stk_stocktransito {
  sql_table_name: `bss_oracle.BT_STK_STOCKTRANSITO` ;;

  dimension: fc_stt_costotranferido {
    type: number
    sql: ${TABLE}.FC_STT_COSTOTRANFERIDO ;;
  }
  dimension: fc_stt_unidadestransferidas {
    type: number
    sql: ${TABLE}.FC_STT_UNIDADESTRANSFERIDAS ;;
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
  dimension: id_mod_origendato {
    type: number
    sql: ${TABLE}.ID_MOD_ORIGENDATO ;;
  }
  dimension: id_pro_hisproveedor {
    type: number
    sql: ${TABLE}.ID_PRO_HISPROVEEDOR ;;
  }
  dimension_group: id_stt_fechatransferencia {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_STT_FECHATRANSFERENCIA ;;
  }
  dimension: id_stt_intercompania {
    type: number
    sql: ${TABLE}.ID_STT_INTERCOMPANIA ;;
  }
  dimension: id_stt_nrotransferencia {
    type: number
    sql: ${TABLE}.ID_STT_NROTRANSFERENCIA ;;
  }
  dimension: id_stt_sucursalrecepcion {
    type: number
    sql: ${TABLE}.ID_STT_SUCURSALRECEPCION ;;
  }
  dimension: id_stt_sucursaltransferencia {
    type: number
    sql: ${TABLE}.ID_STT_SUCURSALTRANSFERENCIA ;;
  }
  dimension: id_tet_transitoencabezadotipo {
    type: number
    sql: ${TABLE}.ID_TET_TRANSITOENCABEZADOTIPO ;;
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
