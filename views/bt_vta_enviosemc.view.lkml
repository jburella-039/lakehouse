view: bt_vta_enviosemc {
  sql_table_name: `bss_oracle.BT_VTA_ENVIOSEMC` ;;

  dimension: fc_vta_costoenvio {
    type: number
    sql: ${TABLE}.FC_VTA_COSTOENVIO ;;
  }
  dimension: fc_vta_precioenvio {
    type: number
    sql: ${TABLE}.FC_VTA_PRECIOENVIO ;;
  }
  dimension: hk_vta_venta {
    type: string
    sql: ${TABLE}.HK_VTA_VENTA ;;
  }
  dimension: id_cli_cliente {
    type: number
    sql: ${TABLE}.ID_CLI_CLIENTE ;;
  }
  dimension: id_suc_caja {
    type: number
    sql: ${TABLE}.ID_SUC_CAJA ;;
  }
  dimension: id_suc_codpostal {
    type: string
    sql: ${TABLE}.ID_SUC_CODPOSTAL ;;
  }
  dimension: id_suc_entrega {
    type: number
    sql: ${TABLE}.ID_SUC_ENTREGA ;;
  }
  dimension: id_suc_nroapertura {
    type: number
    sql: ${TABLE}.ID_SUC_NROAPERTURA ;;
  }
  dimension: id_suc_provincia {
    type: number
    sql: ${TABLE}.ID_SUC_PROVINCIA ;;
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
  dimension_group: id_tie_entrega {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_TIE_ENTREGA ;;
  }
  dimension: id_tkt_nrocomprobante {
    type: number
    sql: ${TABLE}.ID_TKT_NROCOMPROBANTE ;;
  }
  dimension: id_tkt_origenventa {
    type: number
    sql: ${TABLE}.ID_TKT_ORIGENVENTA ;;
  }
  dimension: id_tkt_tipocomprobante {
    type: number
    sql: ${TABLE}.ID_TKT_TIPOCOMPROBANTE ;;
  }
  dimension: id_vta_franjahoraria {
    type: number
    sql: ${TABLE}.ID_VTA_FRANJAHORARIA ;;
  }
  dimension: id_vta_venta {
    type: number
    sql: ${TABLE}.ID_VTA_VENTA ;;
  }
  measure: count {
    type: count
  }
}
