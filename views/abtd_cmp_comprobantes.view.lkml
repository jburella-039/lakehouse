view: abtd_cmp_comprobantes {
  sql_table_name: `bss_oracle.ABTD_CMP_COMPROBANTES` ;;

  dimension: fc_cts_monto {
    type: number
    sql: ${TABLE}.FC_CTS_MONTO ;;
  }
  dimension: fc_cts_montoiva {
    type: number
    sql: ${TABLE}.FC_CTS_MONTOIVA ;;
  }
  dimension: fc_cts_montosiniva {
    type: number
    sql: ${TABLE}.FC_CTS_MONTOSINIVA ;;
  }
  dimension: fc_cts_pib {
    type: number
    sql: ${TABLE}.FC_CTS_PIB ;;
  }
  dimension: id_art_sector {
    type: number
    sql: ${TABLE}.ID_ART_SECTOR ;;
  }
  dimension_group: id_cmb_dia {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_CMB_DIA ;;
  }
  dimension: id_cts_nrofactura {
    type: string
    sql: ${TABLE}.ID_CTS_NROFACTURA ;;
  }
  dimension: id_cts_numero {
    type: string
    sql: ${TABLE}.ID_CTS_NUMERO ;;
  }
  dimension: id_fpp_ppagoletrafactura {
    type: number
    sql: ${TABLE}.ID_FPP_PPAGOLETRAFACTURA ;;
  }
  dimension: id_idr_nroinforme {
    type: number
    value_format_name: id
    sql: ${TABLE}.ID_IDR_NROINFORME ;;
  }
  dimension: id_irt_tipoinformerecepcion {
    type: number
    sql: ${TABLE}.ID_IRT_TIPOINFORMERECEPCION ;;
  }
  dimension: id_pro_proveedor {
    type: number
    sql: ${TABLE}.ID_PRO_PROVEEDOR ;;
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
  dimension: id_tpp_ppagotipocomprobante {
    type: number
    sql: ${TABLE}.ID_TPP_PPAGOTIPOCOMPROBANTE ;;
  }
  measure: count {
    type: count
  }
}
