view: bt_vta_ticketsofertas {
  sql_table_name: `bss_oracle.BT_VTA_TICKETSOFERTAS` ;;

  dimension: fc_art_costocalculado {
    type: number
    sql: ${TABLE}.FC_ART_COSTOCALCULADO ;;
  }
  dimension: fc_opc_preciooferta {
    type: number
    sql: ${TABLE}.FC_OPC_PRECIOOFERTA ;;
  }
  dimension: fc_vta_cantbonificacion {
    type: number
    sql: ${TABLE}.FC_VTA_CANTBONIFICACION ;;
  }
  dimension: fc_vta_cantcupondesc {
    type: number
    sql: ${TABLE}.FC_VTA_CANTCUPONDESC ;;
  }
  dimension: fc_vta_cantidad {
    type: number
    sql: ${TABLE}.FC_VTA_CANTIDAD ;;
  }
  dimension: fc_vta_costo {
    type: number
    sql: ${TABLE}.FC_VTA_COSTO ;;
  }
  dimension: fc_vta_montocupondesc {
    type: number
    sql: ${TABLE}.FC_VTA_MONTOCUPONDESC ;;
  }
  dimension: fc_vta_montoofertadesc {
    type: number
    sql: ${TABLE}.FC_VTA_MONTOOFERTADESC ;;
  }
  dimension: fc_vta_montopromodesc {
    type: number
    sql: ${TABLE}.FC_VTA_MONTOPROMODESC ;;
  }
  dimension: fc_vta_montototal {
    type: number
    sql: ${TABLE}.FC_VTA_MONTOTOTAL ;;
  }
  dimension: fc_vta_porcdesccupon {
    type: number
    sql: ${TABLE}.FC_VTA_PORCDESCCUPON ;;
  }
  dimension: fc_vta_porcdescuento {
    type: number
    sql: ${TABLE}.FC_VTA_PORCDESCUENTO ;;
  }
  dimension: fc_vta_preciostotalsiniva {
    type: number
    sql: ${TABLE}.FC_VTA_PRECIOSTOTALSINIVA ;;
  }
  dimension: fc_vta_totaldescempleado {
    type: number
    sql: ${TABLE}.FC_VTA_TOTALDESCEMPLEADO ;;
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
  dimension: id_art_oferta {
    type: number
    sql: ${TABLE}.ID_ART_OFERTA ;;
  }
  dimension: id_art_tipooferta {
    type: number
    sql: ${TABLE}.ID_ART_TIPOOFERTA ;;
  }
  dimension: id_cli_cliente {
    type: number
    sql: ${TABLE}.ID_CLI_CLIENTE ;;
  }
  dimension: id_cup_cupondesc {
    type: number
    sql: ${TABLE}.ID_CUP_CUPONDESC ;;
  }
  dimension_group: id_fecha_ultimamodificacion {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_FECHA_ULTIMAMODIFICACION ;;
  }
  dimension: id_opc_promogrupo {
    type: number
    sql: ${TABLE}.ID_OPC_PROMOGRUPO ;;
  }
  dimension: id_pro_comercial {
    type: number
    sql: ${TABLE}.ID_PRO_COMERCIAL ;;
  }
  dimension: id_pro_hisproveedor {
    type: number
    sql: ${TABLE}.ID_PRO_HISPROVEEDOR ;;
  }
  dimension: id_rrh_cajero {
    type: number
    sql: ${TABLE}.ID_RRH_CAJERO ;;
  }
  dimension: id_rrh_empleadodesc {
    type: number
    sql: ${TABLE}.ID_RRH_EMPLEADODESC ;;
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
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_TIE_DIA ;;
  }
  dimension: id_tie_mes {
    type: number
    sql: ${TABLE}.ID_TIE_MES ;;
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
  dimension_group: id_vta_fecha {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_VTA_FECHA ;;
  }
  measure: count {
    type: count
  }
}
