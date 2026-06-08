view: bt_vta_granel {
  sql_table_name: `bss_oracle.BT_VTA_GRANEL` ;;

  dimension: fc_vta_gramos {
    type: number
    sql: ${TABLE}.FC_VTA_GRAMOS ;;
  }
  dimension: id_art_cuf {
    type: number
    sql: ${TABLE}.ID_ART_CUF ;;
  }
  dimension: id_suc_caja {
    type: number
    sql: ${TABLE}.ID_SUC_CAJA ;;
  }
  dimension: id_suc_nroapertura {
    type: number
    sql: ${TABLE}.ID_SUC_NROAPERTURA ;;
  }
  dimension: id_suc_sucursal {
    type: number
    sql: ${TABLE}.ID_SUC_SUCURSAL ;;
  }
  dimension_group: id_tie_dia {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ID_TIE_DIA ;;
  }
  dimension: id_tkt_nrocomprobante {
    type: number
    sql: ${TABLE}.ID_TKT_NROCOMPROBANTE ;;
  }
  dimension: id_tkt_tipocomprobante {
    type: number
    sql: ${TABLE}.ID_TKT_TIPOCOMPROBANTE ;;
  }
  measure: count {
    type: count
  }
}
