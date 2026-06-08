view: bt_vta_tickets {
  sql_table_name: `bss_oracle.BT_VTA_TICKETS` ;;

  dimension: cd_doc_asociado_fe {
    type: string
    sql: ${TABLE}.CD_DOC_ASOCIADO_FE ;;
  }
  dimension: cd_tipodoc_asociado_fe {
    type: number
    sql: ${TABLE}.CD_TIPODOC_ASOCIADO_FE ;;
  }
  dimension: cuit_comprador {
    type: string
    sql: ${TABLE}.CUIT_COMPRADOR ;;
  }
  dimension: ds_email_fe {
    type: string
    sql: ${TABLE}.DS_EMAIL_FE ;;
  }
  dimension: ds_envio_domicilio {
    type: string
    sql: ${TABLE}.DS_ENVIO_DOMICILIO ;;
  }
  dimension: fc_msk_costoppp_calc {
    type: number
    sql: ${TABLE}.FC_MSK_COSTOPPP_CALC ;;
  }
  dimension: fc_vta_bonificacion {
    type: number
    sql: ${TABLE}.FC_VTA_BONIFICACION ;;
  }
  dimension: fc_vta_cantbonificacion {
    type: number
    sql: ${TABLE}.FC_VTA_CANTBONIFICACION ;;
  }
  dimension: fc_vta_cantcabecera {
    type: string
    sql: ${TABLE}.FC_VTA_CANTCABECERA ;;
  }
  dimension: fc_vta_cantcupondesc {
    type: number
    sql: ${TABLE}.FC_VTA_CANTCUPONDESC ;;
  }
  dimension: fc_vta_cantidad {
    type: number
    sql: ${TABLE}.FC_VTA_CANTIDAD ;;
  }
  dimension: fc_vta_cantidadfarmacia {
    type: number
    sql: ${TABLE}.FC_VTA_CANTIDADFARMACIA ;;
  }
  dimension: fc_vta_cantpromodesc {
    type: number
    sql: ${TABLE}.FC_VTA_CANTPROMODESC ;;
  }
  dimension: fc_vta_costo {
    type: number
    sql: ${TABLE}.FC_VTA_COSTO ;;
  }
  dimension: fc_vta_descfarmacia {
    type: number
    sql: ${TABLE}.FC_VTA_DESCFARMACIA ;;
  }
  dimension: fc_vta_descfppromo {
    type: number
    sql: ${TABLE}.FC_VTA_DESCFPPROMO ;;
  }
  dimension: fc_vta_iva {
    type: number
    sql: ${TABLE}.FC_VTA_IVA ;;
  }
  dimension: fc_vta_montocoseguro {
    type: number
    sql: ${TABLE}.FC_VTA_MONTOCOSEGURO ;;
  }
  dimension: fc_vta_montocupondesc {
    type: number
    sql: ${TABLE}.FC_VTA_MONTOCUPONDESC ;;
  }
  dimension: fc_vta_montodescfp {
    type: number
    sql: ${TABLE}.FC_VTA_MONTODESCFP ;;
  }
  dimension: fc_vta_montofarmacia {
    type: number
    sql: ${TABLE}.FC_VTA_MONTOFARMACIA ;;
  }
  dimension: fc_vta_montofarmaciatickitems {
    type: number
    sql: ${TABLE}.FC_VTA_MONTOFARMACIATICKITEMS ;;
  }
  dimension: fc_vta_montoimpuestovideo {
    type: number
    sql: ${TABLE}.FC_VTA_MONTOIMPUESTOVIDEO ;;
  }
  dimension: fc_vta_montoos {
    type: number
    sql: ${TABLE}.FC_VTA_MONTOOS ;;
  }
  dimension: fc_vta_montopromodesc {
    type: number
    sql: ${TABLE}.FC_VTA_MONTOPROMODESC ;;
  }
  dimension: fc_vta_montototal {
    type: number
    sql: ${TABLE}.FC_VTA_MONTOTOTAL ;;
  }
  dimension: fc_vta_percepcioniva {
    type: number
    sql: ${TABLE}.FC_VTA_PERCEPCIONIVA ;;
  }
  dimension: fc_vta_porcdesccupon {
    type: number
    sql: ${TABLE}.FC_VTA_PORCDESCCUPON ;;
  }
  dimension: fc_vta_porcpercepcion {
    type: number
    sql: ${TABLE}.FC_VTA_PORCPERCEPCION ;;
  }
  dimension: fc_vta_porcpromodesc {
    type: number
    sql: ${TABLE}.FC_VTA_PORCPROMODESC ;;
  }
  dimension: fc_vta_porcrecfinanciero {
    type: number
    sql: ${TABLE}.FC_VTA_PORCRECFINANCIERO ;;
  }
  dimension: fc_vta_preciostotalsiniva {
    type: number
    sql: ${TABLE}.FC_VTA_PRECIOSTOTALSINIVA ;;
  }
  dimension: fc_vta_preciounitariopublico {
    type: number
    sql: ${TABLE}.FC_VTA_PRECIOUNITARIOPUBLICO ;;
  }
  dimension: fc_vta_totaldescempleado {
    type: number
    sql: ${TABLE}.FC_VTA_TOTALDESCEMPLEADO ;;
  }
  dimension: fc_vta_totaldescempleadociva {
    type: number
    sql: ${TABLE}.FC_VTA_TOTALDESCEMPLEADOCIVA ;;
  }
  dimension: fl_art_gabinetesalud {
    type: number
    sql: ${TABLE}.FL_ART_GABINETESALUD ;;
  }
  dimension: hk_vta_venta {
    type: string
    sql: ${TABLE}.HK_VTA_VENTA ;;
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
  dimension: id_emc_nroorden {
    type: string
    sql: ${TABLE}.ID_EMC_NROORDEN ;;
  }
  dimension: id_emc_nropedido {
    type: number
    sql: ${TABLE}.ID_EMC_NROPEDIDO ;;
  }
  dimension: id_etl_cargadatos {
    type: number
    sql: ${TABLE}.ID_ETL_CARGADATOS ;;
  }
  dimension_group: id_fecha_emisionfacturaelectronica {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_FECHA_EMISIONFACTURAELECTRONICA ;;
  }
  dimension_group: id_fecha_pedido {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_FECHA_PEDIDO ;;
  }
  dimension_group: id_fecha_ultimamodificacion {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_FECHA_ULTIMAMODIFICACION ;;
  }
  dimension: id_hrs_hora {
    type: number
    sql: ${TABLE}.ID_HRS_HORA ;;
  }
  dimension: id_iva_porcentajeiva {
    type: number
    sql: ${TABLE}.ID_IVA_PORCENTAJEIVA ;;
  }
  dimension: id_iva_tipoiva {
    type: number
    sql: ${TABLE}.ID_IVA_TIPOIVA ;;
  }
  dimension: id_mnc_motivonc {
    type: number
    sql: ${TABLE}.ID_MNC_MOTIVONC ;;
  }
  dimension: id_oos_coseguro {
    type: number
    sql: ${TABLE}.ID_OOS_COSEGURO ;;
  }
  dimension: id_oos_nroremito {
    type: number
    sql: ${TABLE}.ID_OOS_NROREMITO ;;
  }
  dimension: id_oos_obrasocial {
    type: number
    sql: ${TABLE}.ID_OOS_OBRASOCIAL ;;
  }
  dimension: id_pro_comercial {
    type: number
    sql: ${TABLE}.ID_PRO_COMERCIAL ;;
  }
  dimension: id_pro_hisproveedor {
    type: number
    sql: ${TABLE}.ID_PRO_HISPROVEEDOR ;;
  }
  dimension: id_rrh_autorizador {
    type: number
    sql: ${TABLE}.ID_RRH_AUTORIZADOR ;;
  }
  dimension: id_rrh_cajero {
    type: number
    sql: ${TABLE}.ID_RRH_CAJERO ;;
  }
  dimension: id_rrh_empleado {
    type: number
    sql: ${TABLE}.ID_RRH_EMPLEADO ;;
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
  dimension: id_suc_pdvfiscal {
    type: number
    sql: ${TABLE}.ID_SUC_PDVFISCAL ;;
  }
  dimension: id_suc_sucursal {
    type: number
    sql: ${TABLE}.ID_SUC_SUCURSAL ;;
  }
  dimension: id_suc_sucursal_pet {
    type: number
    sql: ${TABLE}.ID_SUC_SUCURSAL_PET ;;
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
  dimension: id_tip_histiporotdemanda {
    type: number
    sql: ${TABLE}.ID_TIP_HISTIPOROTDEMANDA ;;
  }
  dimension: id_tip_histiporotmargen {
    type: number
    sql: ${TABLE}.ID_TIP_HISTIPOROTMARGEN ;;
  }
  dimension: id_tip_histiporotvolumen {
    type: number
    sql: ${TABLE}.ID_TIP_HISTIPOROTVOLUMEN ;;
  }
  dimension: id_tkt_nrocomprobante {
    type: number
    sql: ${TABLE}.ID_TKT_NROCOMPROBANTE ;;
  }
  dimension: id_tkt_nrocomprobanteafip {
    type: number
    sql: ${TABLE}.ID_TKT_NROCOMPROBANTEAFIP ;;
  }
  dimension: id_tkt_origenventa {
    type: number
    sql: ${TABLE}.ID_TKT_ORIGENVENTA ;;
  }
  dimension: id_tkt_tipocomprobante {
    type: number
    sql: ${TABLE}.ID_TKT_TIPOCOMPROBANTE ;;
  }
  dimension: id_tuf_usuario {
    type: number
    sql: ${TABLE}.ID_TUF_USUARIO ;;
  }
  dimension: id_vta_cliente {
    type: number
    sql: ${TABLE}.ID_VTA_CLIENTE ;;
  }
  dimension_group: id_vta_fecha {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_VTA_FECHA ;;
  }
  dimension_group: id_vta_fechaescaneo {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_VTA_FECHAESCANEO ;;
  }
  dimension: id_vta_nrocupon {
    type: number
    sql: ${TABLE}.ID_VTA_NROCUPON ;;
  }
  dimension: id_vta_nrolote {
    type: number
    sql: ${TABLE}.ID_VTA_NROLOTE ;;
  }
  dimension: id_vta_nroterminal {
    type: number
    sql: ${TABLE}.ID_VTA_NROTERMINAL ;;
  }
  dimension: id_vta_porcpercepcioniva {
    type: number
    sql: ${TABLE}.ID_VTA_PORCPERCEPCIONIVA ;;
  }
  dimension: id_vta_sexo {
    type: number
    sql: ${TABLE}.ID_VTA_SEXO ;;
  }
  dimension: id_vta_tipooperacioncomercial {
    type: number
    sql: ${TABLE}.ID_VTA_TIPOOPERACIONCOMERCIAL ;;
  }
  dimension: id_vta_venta {
    type: number
    sql: ${TABLE}.ID_VTA_VENTA ;;
  }
  measure: count {
    type: count
  }
}
