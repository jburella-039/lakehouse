view: bt_vta_ticketsformapago {
  sql_table_name: `bss_oracle.BT_VTA_TICKETSFORMAPAGO` ;;

  dimension: cd_cli_cuil {
    type: string
    sql: ${TABLE}.CD_CLI_CUIL ;;
  }
  dimension: cd_doc_asociado_fe {
    type: string
    sql: ${TABLE}.CD_DOC_ASOCIADO_FE ;;
  }
  dimension: cd_operacion_lastmile {
    type: string
    sql: ${TABLE}.CD_OPERACION_LASTMILE ;;
  }
  dimension: cd_pag_walletorder {
    type: string
    sql: ${TABLE}.CD_PAG_WALLETORDER ;;
  }
  dimension: cd_pag_wallettransaction {
    type: string
    sql: ${TABLE}.CD_PAG_WALLETTRANSACTION ;;
  }
  dimension: cd_tipodoc_asociado_fe {
    type: number
    sql: ${TABLE}.CD_TIPODOC_ASOCIADO_FE ;;
  }
  dimension: cd_vta_codigocomercio {
    type: string
    sql: ${TABLE}.CD_VTA_CODIGOCOMERCIO ;;
  }
  dimension: cd_vta_numeroautorizacion {
    type: string
    sql: ${TABLE}.CD_VTA_NUMEROAUTORIZACION ;;
  }
  dimension: cd_vta_numerotarjeta {
    type: string
    sql: ${TABLE}.CD_VTA_NUMEROTARJETA ;;
  }
  dimension: ds_email_fe {
    type: string
    sql: ${TABLE}.DS_EMAIL_FE ;;
  }
  dimension: ds_fe_metodo_envio {
    type: string
    sql: ${TABLE}.DS_FE_METODO_ENVIO ;;
  }
  dimension: ds_pag_nombretarjeta {
    type: string
    sql: ${TABLE}.DS_PAG_NOMBRETARJETA ;;
  }
  dimension: ds_uso_modo {
    type: string
    sql: ${TABLE}.DS_USO_MODO ;;
  }
  dimension: ds_uso_plan_gobierno {
    type: string
    sql: ${TABLE}.DS_USO_PLAN_GOBIERNO ;;
  }
  dimension: fc_tfp_monto {
    type: number
    sql: ${TABLE}.FC_TFP_MONTO ;;
  }
  dimension: fc_tfp_monto_cotizacion {
    type: number
    sql: ${TABLE}.FC_TFP_MONTO_COTIZACION ;;
  }
  dimension: fc_tfp_montoentregado {
    type: number
    sql: ${TABLE}.FC_TFP_MONTOENTREGADO ;;
  }
  dimension: fc_tfp_montototal {
    type: number
    sql: ${TABLE}.FC_TFP_MONTOTOTAL ;;
  }
  dimension: fc_tfp_montototalfarmacia {
    type: number
    sql: ${TABLE}.FC_TFP_MONTOTOTALFARMACIA ;;
  }
  dimension: fc_tfp_montototalooss {
    type: number
    sql: ${TABLE}.FC_TFP_MONTOTOTALOOSS ;;
  }
  dimension: fc_vta_montodescfp {
    type: number
    sql: ${TABLE}.FC_VTA_MONTODESCFP ;;
  }
  dimension: fc_vta_montodescfp_civa {
    type: number
    sql: ${TABLE}.FC_VTA_MONTODESCFP_CIVA ;;
  }
  dimension: fl_cashback {
    type: number
    sql: ${TABLE}.FL_CASHBACK ;;
  }
  dimension: fl_mult_medio_pago {
    type: number
    sql: ${TABLE}.FL_MULT_MEDIO_PAGO ;;
  }
  dimension: id_ecm_pkgmeli {
    type: string
    sql: ${TABLE}.ID_ECM_PKGMELI ;;
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
  dimension_group: id_fecha_pedido {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_FECHA_PEDIDO ;;
  }
  dimension_group: id_fecha_pedido_sin_hora {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_FECHA_PEDIDO_SIN_HORA ;;
  }
  dimension: id_pag_mediopago {
    type: number
    sql: ${TABLE}.ID_PAG_MEDIOPAGO ;;
  }
  dimension: id_pag_modoingreso {
    type: number
    sql: ${TABLE}.ID_PAG_MODOINGRESO ;;
  }
  dimension: id_rrh_cajero {
    type: number
    sql: ${TABLE}.ID_RRH_CAJERO ;;
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
  dimension: id_tfp_cuotasxfp {
    type: number
    sql: ${TABLE}.ID_TFP_CUOTASXFP ;;
  }
  dimension_group: id_tfp_fecha {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_TFP_FECHA ;;
  }
  dimension: id_tfp_nrocomprobantexfp {
    type: number
    sql: ${TABLE}.ID_TFP_NROCOMPROBANTEXFP ;;
  }
  dimension: id_tfp_nrooperacion {
    type: number
    sql: ${TABLE}.ID_TFP_NROOPERACION ;;
  }
  dimension: id_tfp_numeropago {
    type: number
    sql: ${TABLE}.ID_TFP_NUMEROPAGO ;;
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
  dimension: id_vta_banco {
    type: number
    sql: ${TABLE}.ID_VTA_BANCO ;;
  }
  dimension: id_vta_binbanco {
    type: string
    sql: ${TABLE}.ID_VTA_BINBANCO ;;
  }
  dimension: id_vta_meli {
    type: string
    sql: ${TABLE}.ID_VTA_MELI ;;
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
  measure: count {
    type: count
  }
}
