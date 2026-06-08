view: abt_informesrecepcion {
  sql_table_name: `bss_oracle.ABT_INFORMESRECEPCION` ;;

  dimension: fc_idr_cantidad {
    type: number
    value_format_name: id
    sql: ${TABLE}.FC_IDR_CANTIDAD ;;
  }
  dimension: fc_idr_cantidadajustada {
    type: number
    value_format_name: id
    sql: ${TABLE}.FC_IDR_CANTIDADAJUSTADA ;;
  }
  dimension: fc_idr_cantidadajustes {
    type: number
    value_format_name: id
    sql: ${TABLE}.FC_IDR_CANTIDADAJUSTES ;;
  }
  dimension: fc_idr_cantidaditems {
    type: number
    value_format_name: id
    sql: ${TABLE}.FC_IDR_CANTIDADITEMS ;;
  }
  dimension: fc_idr_costo {
    type: number
    value_format_name: id
    sql: ${TABLE}.FC_IDR_COSTO ;;
  }
  dimension: fc_idr_plazopago {
    type: number
    value_format_name: id
    sql: ${TABLE}.FC_IDR_PLAZOPAGO ;;
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
  dimension: id_art_histsubcategoria {
    type: number
    sql: ${TABLE}.ID_ART_HISTSUBCATEGORIA ;;
  }
  dimension: id_cdp_condicionpago {
    type: number
    sql: ${TABLE}.ID_CDP_CONDICIONPAGO ;;
  }
  dimension: id_epp_ppagoestado {
    type: number
    sql: ${TABLE}.ID_EPP_PPAGOESTADO ;;
  }
  dimension_group: id_idr_fecha {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_IDR_FECHA ;;
  }
  dimension_group: id_idr_fechacondpago {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ID_IDR_FECHACONDPAGO ;;
  }
  dimension: id_idr_nrocomprobante {
    type: number
    value_format_name: id
    sql: ${TABLE}.ID_IDR_NROCOMPROBANTE ;;
  }
  dimension: id_idr_nroinforme {
    type: number
    value_format_name: id
    sql: ${TABLE}.ID_IDR_NROINFORME ;;
  }
  dimension: id_idr_observaciones {
    type: string
    sql: ${TABLE}.ID_IDR_OBSERVACIONES ;;
  }
  dimension: id_idr_origencomprobante {
    type: number
    value_format_name: id
    sql: ${TABLE}.ID_IDR_ORIGENCOMPROBANTE ;;
  }
  dimension: id_idr_responsable {
    type: string
    sql: ${TABLE}.ID_IDR_RESPONSABLE ;;
  }
  dimension: id_ire_informerecepcionestado {
    type: number
    sql: ${TABLE}.ID_IRE_INFORMERECEPCIONESTADO ;;
  }
  dimension: id_irt_tipoinformerecepcion {
    type: number
    sql: ${TABLE}.ID_IRT_TIPOINFORMERECEPCION ;;
  }
  dimension: id_mod_origendato {
    type: number
    sql: ${TABLE}.ID_MOD_ORIGENDATO ;;
  }
  dimension: id_pdp_pedidopago {
    type: number
    sql: ${TABLE}.ID_PDP_PEDIDOPAGO ;;
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
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ID_TIE_DIA ;;
  }
  dimension_group: id_tie_fechainsercion_dw {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_TIE_FECHAINSERCION_DW ;;
  }
  dimension_group: id_tie_fechaultimamodificacion_dw {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ID_TIE_FECHAULTIMAMODIFICACION_DW ;;
  }
  dimension: id_tie_horaultimamodificacion_dw {
    type: number
    sql: ${TABLE}.ID_TIE_HORAULTIMAMODIFICACION_DW ;;
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
