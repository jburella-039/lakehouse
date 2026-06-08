view: bt_vta_farmacia {
  sql_table_name: `bss_oracle.BT_VTA_FARMACIA` ;;

  dimension: cd_art_tipoprescripcion {
    type: string
    sql: ${TABLE}.CD_ART_TIPOPRESCRIPCION ;;
  }
  dimension: cd_tkf_codautorizacion_cos {
    type: string
    sql: ${TABLE}.CD_TKF_CODAUTORIZACION_COS ;;
  }
  dimension: cd_tkf_codcancelacion_cos {
    type: string
    sql: ${TABLE}.CD_TKF_CODCANCELACION_COS ;;
  }
  dimension: ds_vta_dispensa {
    type: string
    sql: ${TABLE}.DS_VTA_DISPENSA ;;
  }
  dimension: ds_vta_nombreafiliadocos {
    type: string
    sql: ${TABLE}.DS_VTA_NOMBREAFILIADOCOS ;;
  }
  dimension: ds_vta_nombreafiliadoos {
    type: string
    sql: ${TABLE}.DS_VTA_NOMBREAFILIADOOS ;;
  }
  dimension: ds_vta_nombremedico {
    type: string
    sql: ${TABLE}.DS_VTA_NOMBREMEDICO ;;
  }
  dimension: ds_vta_nroafiliadocos {
    type: string
    sql: ${TABLE}.DS_VTA_NROAFILIADOCOS ;;
  }
  dimension: ds_vta_nroafiliadoos {
    type: string
    sql: ${TABLE}.DS_VTA_NROAFILIADOOS ;;
  }
  dimension: fc_tkf_cantidad {
    type: number
    sql: ${TABLE}.FC_TKF_CANTIDAD ;;
  }
  dimension: fc_tkf_costofarmacia {
    type: number
    sql: ${TABLE}.FC_TKF_COSTOFARMACIA ;;
  }
  dimension: fc_tkf_costototal {
    type: number
    sql: ${TABLE}.FC_TKF_COSTOTOTAL ;;
  }
  dimension: fc_tkf_descfarmacia {
    type: number
    sql: ${TABLE}.FC_TKF_DESCFARMACIA ;;
  }
  dimension: fc_tkf_montoacobrar {
    type: number
    sql: ${TABLE}.FC_TKF_MONTOACOBRAR ;;
  }
  dimension: fc_tkf_montocos {
    type: number
    sql: ${TABLE}.FC_TKF_MONTOCOS ;;
  }
  dimension: fc_tkf_montocupondesc {
    type: number
    sql: ${TABLE}.FC_TKF_MONTOCUPONDESC ;;
  }
  dimension: fc_tkf_montodescefectivo {
    type: number
    sql: ${TABLE}.FC_TKF_MONTODESCEFECTIVO ;;
  }
  dimension: fc_tkf_montodescempleado {
    type: number
    sql: ${TABLE}.FC_TKF_MONTODESCEMPLEADO ;;
  }
  dimension: fc_tkf_montodescfp {
    type: number
    sql: ${TABLE}.FC_TKF_MONTODESCFP ;;
  }
  dimension: fc_tkf_montoos {
    type: number
    sql: ${TABLE}.FC_TKF_MONTOOS ;;
  }
  dimension: fc_tkf_montototal {
    type: number
    sql: ${TABLE}.FC_TKF_MONTOTOTAL ;;
  }
  dimension: fc_tkf_montototalsiniva {
    type: number
    sql: ${TABLE}.FC_TKF_MONTOTOTALSINIVA ;;
  }
  dimension: fc_tkf_totaldescempleado {
    type: number
    sql: ${TABLE}.FC_TKF_TOTALDESCEMPLEADO ;;
  }
  dimension: fl_vta_presentaciondigital {
    type: number
    sql: ${TABLE}.FL_VTA_PRESENTACIONDIGITAL ;;
  }
  dimension: hk_vta_venta {
    type: string
    sql: ${TABLE}.HK_VTA_VENTA ;;
  }
  dimension: id_art_cuf {
    type: number
    sql: ${TABLE}.ID_ART_CUF ;;
  }
  dimension: id_art_generico {
    type: number
    sql: ${TABLE}.ID_ART_GENERICO ;;
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
  dimension: id_cli_cliente {
    type: number
    sql: ${TABLE}.ID_CLI_CLIENTE ;;
  }
  dimension: id_etl_cargadatos {
    type: number
    sql: ${TABLE}.ID_ETL_CARGADATOS ;;
  }
  dimension: id_frm_estadoremito {
    type: number
    sql: ${TABLE}.ID_FRM_ESTADOREMITO ;;
  }
  dimension: id_frm_tiporemito {
    type: number
    sql: ${TABLE}.ID_FRM_TIPOREMITO ;;
  }
  dimension: id_hrs_hora {
    type: number
    sql: ${TABLE}.ID_HRS_HORA ;;
  }
  dimension: id_iva_tipoiva {
    type: number
    sql: ${TABLE}.ID_IVA_TIPOIVA ;;
  }
  dimension: id_luf_cliente {
    type: number
    sql: ${TABLE}.ID_LUF_CLIENTE ;;
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
  dimension: id_rhh_responsableautorizacion {
    type: number
    sql: ${TABLE}.ID_RHH_RESPONSABLEAUTORIZACION ;;
  }
  dimension: id_rrh_vendedor {
    type: number
    sql: ${TABLE}.ID_RRH_VENDEDOR ;;
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
  dimension: id_tkf_codautorizacion {
    type: string
    sql: ${TABLE}.ID_TKF_CODAUTORIZACION ;;
  }
  dimension: id_tkf_codcancelacion {
    type: string
    sql: ${TABLE}.ID_TKF_CODCANCELACION ;;
  }
  dimension: id_tkf_descautorizacion {
    type: string
    sql: ${TABLE}.ID_TKF_DESCAUTORIZACION ;;
  }
  dimension: id_tkf_dispensatipo {
    type: number
    sql: ${TABLE}.ID_TKF_DISPENSATIPO ;;
  }
  dimension_group: id_tkf_fechahora {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_TKF_FECHAHORA ;;
  }
  dimension: id_tkf_nropreparado {
    type: number
    sql: ${TABLE}.ID_TKF_NROPREPARADO ;;
  }
  dimension: id_tkf_nroreceta {
    type: number
    sql: ${TABLE}.ID_TKF_NRORECETA ;;
  }
  dimension: id_tkf_nrovaleasociado {
    type: number
    sql: ${TABLE}.ID_TKF_NROVALEASOCIADO ;;
  }
  dimension: id_tkf_pdvf {
    type: number
    sql: ${TABLE}.ID_TKF_PDVF ;;
  }
  dimension: id_tkf_tipoplan_cos {
    type: number
    sql: ${TABLE}.ID_TKF_TIPOPLAN_COS ;;
  }
  dimension: id_tkf_tipoplan_os {
    type: number
    sql: ${TABLE}.ID_TKF_TIPOPLAN_OS ;;
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
  dimension: id_vta_esrecetadigital {
    type: number
    sql: ${TABLE}.ID_VTA_ESRECETADIGITAL ;;
  }
  dimension_group: id_vta_fechahoraingreso {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_VTA_FECHAHORAINGRESO ;;
  }
  dimension_group: id_vta_horaemisionticket {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_VTA_HORAEMISIONTICKET ;;
  }
  dimension: id_vta_nromatricula {
    type: number
    sql: ${TABLE}.ID_VTA_NROMATRICULA ;;
  }
  dimension: id_vta_psicotropico {
    type: number
    sql: ${TABLE}.ID_VTA_PSICOTROPICO ;;
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
