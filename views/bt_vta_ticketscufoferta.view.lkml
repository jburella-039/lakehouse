view: bt_vta_ticketscufoferta {
  sql_table_name: `bss_oracle.BT_VTA_TICKETSCUFOFERTA` ;;

  dimension: ds_vta_oferta_desc {
    type: string
    sql: ${TABLE}.DS_VTA_OFERTA_DESC ;;
  }
  dimension: fc_vta_oferta_cantidad {
    type: number
    sql: ${TABLE}.FC_VTA_OFERTA_CANTIDAD ;;
  }
  dimension: fc_vta_oferta_monto {
    type: number
    sql: ${TABLE}.FC_VTA_OFERTA_MONTO ;;
  }
  dimension: fc_vta_oferta_porc {
    type: number
    sql: ${TABLE}.FC_VTA_OFERTA_PORC ;;
  }
  dimension: id_art_cuf {
    type: string
    sql: ${TABLE}.ID_ART_CUF ;;
  }
  dimension: id_art_oferta {
    type: number
    sql: ${TABLE}.ID_ART_OFERTA ;;
  }
  dimension: id_cli_cliente {
    type: number
    sql: ${TABLE}.ID_CLI_CLIENTE ;;
  }
  dimension: id_pro_comercial {
    type: number
    sql: ${TABLE}.ID_PRO_COMERCIAL ;;
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
    type: string
    sql: ${TABLE}.ID_TKT_TIPOCOMPROBANTE ;;
  }
  dimension: id_tuf_usuario {
    type: number
    sql: ${TABLE}.ID_TUF_USUARIO ;;
  }
  measure: count {
    type: count
  }
}
