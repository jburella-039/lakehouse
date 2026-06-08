view: bt_vta_posvoucher {
  sql_table_name: `bss_oracle.BT_VTA_POSVOUCHER` ;;

  dimension: cd_vta_codigocomercio {
    type: string
    sql: ${TABLE}.CD_VTA_CODIGOCOMERCIO ;;
  }
  dimension: cd_vta_mesvencimiento {
    type: string
    sql: ${TABLE}.CD_VTA_MESVENCIMIENTO ;;
  }
  dimension: cd_vta_nroautorizacion_alfanum {
    type: string
    sql: ${TABLE}.CD_VTA_NROAUTORIZACION_ALFANUM ;;
  }
  dimension: cd_vta_nrocuenta {
    type: number
    sql: ${TABLE}.CD_VTA_NROCUENTA ;;
  }
  dimension: cd_vta_nrotarjeta {
    type: string
    sql: ${TABLE}.CD_VTA_NROTARJETA ;;
  }
  dimension: cd_vta_postransacidentidad {
    type: number
    sql: ${TABLE}.CD_VTA_POSTRANSACIDENTIDAD ;;
  }
  dimension: cd_vta_postransacreferencia {
    type: number
    sql: ${TABLE}.CD_VTA_POSTRANSACREFERENCIA ;;
  }
  dimension: cd_vta_postransactipomoneda {
    type: number
    sql: ${TABLE}.CD_VTA_POSTRANSACTIPOMONEDA ;;
  }
  dimension: cd_vta_postransactipooperacion {
    type: number
    sql: ${TABLE}.CD_VTA_POSTRANSACTIPOOPERACION ;;
  }
  dimension: cd_vta_tipocuenta {
    type: number
    sql: ${TABLE}.CD_VTA_TIPOCUENTA ;;
  }
  dimension: cd_vta_tipoingreso {
    type: string
    sql: ${TABLE}.CD_VTA_TIPOINGRESO ;;
  }
  dimension: cd_vta_tipooperacion {
    type: string
    sql: ${TABLE}.CD_VTA_TIPOOPERACION ;;
  }
  dimension: cd_vta_tipoplan {
    type: string
    sql: ${TABLE}.CD_VTA_TIPOPLAN ;;
  }
  dimension: cd_vta_tipovoucher {
    type: number
    sql: ${TABLE}.CD_VTA_TIPOVOUCHER ;;
  }
  dimension: ds_rrh_nombreempleado {
    type: string
    sql: ${TABLE}.DS_RRH_NOMBREEMPLEADO ;;
  }
  dimension: ds_vta_error {
    type: string
    sql: ${TABLE}.DS_VTA_ERROR ;;
  }
  dimension: ds_vta_nombrecliente {
    type: string
    sql: ${TABLE}.DS_VTA_NOMBRECLIENTE ;;
  }
  dimension: ds_vta_nombretarjeta {
    type: string
    sql: ${TABLE}.DS_VTA_NOMBRETARJETA ;;
  }
  dimension: ds_vta_respuestapromocion {
    type: string
    sql: ${TABLE}.DS_VTA_RESPUESTAPROMOCION ;;
  }
  dimension: fc_vta_cantidadcopias {
    type: number
    sql: ${TABLE}.FC_VTA_CANTIDADCOPIAS ;;
  }
  dimension: fc_vta_cantidadcuotas {
    type: number
    sql: ${TABLE}.FC_VTA_CANTIDADCUOTAS ;;
  }
  dimension_group: fc_vta_fechaorigen {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.FC_VTA_FECHAORIGEN ;;
  }
  dimension: fc_vta_monto {
    type: number
    sql: ${TABLE}.FC_VTA_MONTO ;;
  }
  dimension: fc_vta_montocashback {
    type: number
    sql: ${TABLE}.FC_VTA_MONTOCASHBACK ;;
  }
  dimension: fc_vta_nrocomprobanteasociado {
    type: number
    sql: ${TABLE}.FC_VTA_NROCOMPROBANTEASOCIADO ;;
  }
  dimension: fc_vta_nrocuponorig {
    type: number
    sql: ${TABLE}.FC_VTA_NROCUPONORIG ;;
  }
  dimension: fc_vta_nrooperacion {
    type: number
    sql: ${TABLE}.FC_VTA_NROOPERACION ;;
  }
  dimension: fc_vta_nroterminal {
    type: number
    sql: ${TABLE}.FC_VTA_NROTERMINAL ;;
  }
  dimension: fc_vta_reintentos {
    type: number
    sql: ${TABLE}.FC_VTA_REINTENTOS ;;
  }
  dimension: fl_vta_error {
    type: number
    sql: ${TABLE}.FL_VTA_ERROR ;;
  }
  dimension: fl_vta_impreso {
    type: number
    sql: ${TABLE}.FL_VTA_IMPRESO ;;
  }
  dimension: fl_vta_ocultaraclaracion {
    type: number
    sql: ${TABLE}.FL_VTA_OCULTARACLARACION ;;
  }
  dimension: fl_vta_ocultardocumento {
    type: number
    sql: ${TABLE}.FL_VTA_OCULTARDOCUMENTO ;;
  }
  dimension: fl_vta_ocultarfirma {
    type: number
    sql: ${TABLE}.FL_VTA_OCULTARFIRMA ;;
  }
  dimension: fl_vta_ocultarplan {
    type: number
    sql: ${TABLE}.FL_VTA_OCULTARPLAN ;;
  }
  dimension: fl_vta_ocultartipocuenta {
    type: number
    sql: ${TABLE}.FL_VTA_OCULTARTIPOCUENTA ;;
  }
  dimension: fl_vta_ticketactivo {
    type: number
    sql: ${TABLE}.FL_VTA_TICKETACTIVO ;;
  }
  dimension: id_pag_mediopago {
    type: number
    sql: ${TABLE}.ID_PAG_MEDIOPAGO ;;
  }
  dimension: id_pag_tipomoneda {
    type: number
    sql: ${TABLE}.ID_PAG_TIPOMONEDA ;;
  }
  dimension: id_pag_tipotarjeta {
    type: number
    sql: ${TABLE}.ID_PAG_TIPOTARJETA ;;
  }
  dimension: id_rrh_empleado {
    type: number
    sql: ${TABLE}.ID_RRH_EMPLEADO ;;
  }
  dimension: id_sdv_sistemavalidacion {
    type: number
    sql: ${TABLE}.ID_SDV_SISTEMAVALIDACION ;;
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
  dimension: id_vta_cliente {
    type: string
    sql: ${TABLE}.ID_VTA_CLIENTE ;;
  }
  dimension: id_vta_nroautorizacion {
    type: number
    sql: ${TABLE}.ID_VTA_NROAUTORIZACION ;;
  }
  dimension: id_vta_nrocupon {
    type: number
    sql: ${TABLE}.ID_VTA_NROCUPON ;;
  }
  dimension: id_vta_nrolote {
    type: number
    sql: ${TABLE}.ID_VTA_NROLOTE ;;
  }
  dimension: id_vta_nrotarjeta {
    type: string
    sql: ${TABLE}.ID_VTA_NROTARJETA ;;
  }
  dimension: ld_obj_cargadopor {
    type: string
    sql: ${TABLE}.LD_OBJ_CARGADOPOR ;;
  }
  measure: count {
    type: count
  }
}
