view: dim_vta_ticketsformapagoxcuf {
  sql_table_name: `bss_oracle.DIM_VTA_TICKETSFORMAPAGOXCUF` ;;

  dimension: ds_uso_plan_gobierno {
    type: string
    sql: ${TABLE}.DS_USO_PLAN_GOBIERNO ;;
  }
  dimension: fc_tfp_cantidadxfp {
    type: number
    sql: ${TABLE}.FC_TFP_CANTIDADXFP ;;
  }
  dimension: fc_tpf_cantidadoperaciones {
    type: number
    sql: ${TABLE}.FC_TPF_CANTIDADOPERACIONES ;;
  }
  dimension: fc_tpf_cantidadoperacionesxfp {
    type: number
    sql: ${TABLE}.FC_TPF_CANTIDADOPERACIONESXFP ;;
  }
  dimension: fc_tpf_montofarmacia {
    type: number
    sql: ${TABLE}.FC_TPF_MONTOFARMACIA ;;
  }
  dimension: fc_tpf_montoooss {
    type: number
    sql: ${TABLE}.FC_TPF_MONTOOOSS ;;
  }
  dimension: fc_tpf_montototal {
    type: number
    sql: ${TABLE}.FC_TPF_MONTOTOTAL ;;
  }
  dimension: fc_tpf_prcxnivel {
    type: number
    sql: ${TABLE}.FC_TPF_PRCXNIVEL ;;
  }
  dimension: fc_vta_costoxfp {
    type: number
    sql: ${TABLE}.FC_VTA_COSTOXFP ;;
  }
  dimension: fc_vta_preciostotalsiniva {
    type: number
    sql: ${TABLE}.FC_VTA_PRECIOSTOTALSINIVA ;;
  }
  dimension: fc_vta_preciostotalsinivaxfp {
    type: number
    sql: ${TABLE}.FC_VTA_PRECIOSTOTALSINIVAXFP ;;
  }
  dimension: fc_vta_preciounitariopublico {
    type: number
    sql: ${TABLE}.FC_VTA_PRECIOUNITARIOPUBLICO ;;
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
  dimension_group: id_fecha_pedido {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_FECHA_PEDIDO ;;
  }
  dimension: id_pag_mediopago {
    type: number
    sql: ${TABLE}.ID_PAG_MEDIOPAGO ;;
  }
  dimension: id_pag_tipoforma {
    type: number
    sql: ${TABLE}.ID_PAG_TIPOFORMA ;;
  }
  dimension: id_pro_hisproveedor {
    type: number
    sql: ${TABLE}.ID_PRO_HISPROVEEDOR ;;
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
  dimension: id_suc_tiporelacion {
    type: number
    sql: ${TABLE}.ID_SUC_TIPORELACION ;;
  }
  dimension: id_tfp_cuotasxfp {
    type: number
    sql: ${TABLE}.ID_TFP_CUOTASXFP ;;
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
  dimension: id_tkt_esventa {
    type: number
    sql: ${TABLE}.ID_TKT_ESVENTA ;;
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
  dimension: id_vta_tipooperacioncomercial {
    type: number
    sql: ${TABLE}.ID_VTA_TIPOOPERACIONCOMERCIAL ;;
  }
  measure: count {
    type: count
  }
}
