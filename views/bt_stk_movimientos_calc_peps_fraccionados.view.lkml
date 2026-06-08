view: bt_stk_movimientos_calc_peps_fraccionados {
  sql_table_name: `bss_oracle.BT_STK_MOVIMIENTOS_CALC_PEPS_FRACCIONADOS` ;;

  dimension: ds_msk_observaciones {
    type: string
    sql: ${TABLE}.DS_MSK_OBSERVACIONES ;;
  }
  dimension: ds_stk_observaciones_stockciclico {
    type: string
    sql: ${TABLE}.DS_STK_OBSERVACIONES_STOCKCICLICO ;;
  }
  dimension: fc_art_costocalcdiario {
    type: number
    sql: ${TABLE}.FC_ART_COSTOCALCDIARIO ;;
  }
  dimension: fc_msk_cantidad {
    type: number
    sql: ${TABLE}.FC_MSK_CANTIDAD ;;
  }
  dimension: fc_msk_cantidadrecibida {
    type: number
    sql: ${TABLE}.FC_MSK_CANTIDADRECIBIDA ;;
  }
  dimension: fc_msk_costo {
    type: number
    sql: ${TABLE}.FC_MSK_COSTO ;;
  }
  dimension: fc_msk_costorecibido {
    type: number
    sql: ${TABLE}.FC_MSK_COSTORECIBIDO ;;
  }
  dimension: fc_msk_costototal {
    type: number
    sql: ${TABLE}.FC_MSK_COSTOTOTAL ;;
  }
  dimension: fc_msk_costounitario {
    type: number
    sql: ${TABLE}.FC_MSK_COSTOUNITARIO ;;
  }
  dimension: fc_msk_ivatotal {
    type: number
    sql: ${TABLE}.FC_MSK_IVATOTAL ;;
  }
  dimension: fc_msk_montocoseguro {
    type: number
    sql: ${TABLE}.FC_MSK_MONTOCOSEGURO ;;
  }
  dimension: fc_msk_montodescfarmacia {
    type: number
    sql: ${TABLE}.FC_MSK_MONTODESCFARMACIA ;;
  }
  dimension: fc_msk_montoooss {
    type: number
    sql: ${TABLE}.FC_MSK_MONTOOOSS ;;
  }
  dimension: fc_msk_montototal {
    type: number
    sql: ${TABLE}.FC_MSK_MONTOTOTAL ;;
  }
  dimension: fc_msk_preciototalsiniva {
    type: number
    sql: ${TABLE}.FC_MSK_PRECIOTOTALSINIVA ;;
  }
  dimension: id_art_area {
    type: number
    sql: ${TABLE}.ID_ART_AREA ;;
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
  dimension: id_etl_cargadatos {
    type: number
    sql: ${TABLE}.ID_ETL_CARGADATOS ;;
  }
  dimension: id_etl_tabla {
    type: number
    sql: ${TABLE}.ID_ETL_TABLA ;;
  }
  dimension: id_msk_afectastock {
    type: string
    sql: ${TABLE}.ID_MSK_AFECTASTOCK ;;
  }
  dimension: id_msk_estado {
    type: string
    sql: ${TABLE}.ID_MSK_ESTADO ;;
  }
  dimension_group: id_msk_fechahora {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_MSK_FECHAHORA ;;
  }
  dimension_group: id_msk_fechahorarecepcion {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_MSK_FECHAHORARECEPCION ;;
  }
  dimension_group: id_msk_fechahorasalidatransf {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_MSK_FECHAHORASALIDATRANSF ;;
  }
  dimension: id_msk_nroapertura {
    type: number
    sql: ${TABLE}.ID_MSK_NROAPERTURA ;;
  }
  dimension: id_msk_nrocaja {
    type: number
    sql: ${TABLE}.ID_MSK_NROCAJA ;;
  }
  dimension: id_msk_nrocomprobante {
    type: number
    sql: ${TABLE}.ID_MSK_NROCOMPROBANTE ;;
  }
  dimension: id_msk_nropedidoorigen {
    type: number
    sql: ${TABLE}.ID_MSK_NROPEDIDOORIGEN ;;
  }
  dimension: id_msk_nrorecepcion {
    type: number
    sql: ${TABLE}.ID_MSK_NRORECEPCION ;;
  }
  dimension: id_msk_nroremito {
    type: number
    sql: ${TABLE}.ID_MSK_NROREMITO ;;
  }
  dimension: id_msk_nrotransferenciarecibid {
    type: number
    value_format_name: id
    sql: ${TABLE}.ID_MSK_NROTRANSFERENCIARECIBID ;;
  }
  dimension: id_msk_sucursaltransferencia {
    type: number
    sql: ${TABLE}.ID_MSK_SUCURSALTRANSFERENCIA ;;
  }
  dimension: id_msk_usuarioautoriza {
    type: number
    sql: ${TABLE}.ID_MSK_USUARIOAUTORIZA ;;
  }
  dimension: id_pro_hisproveedor {
    type: number
    sql: ${TABLE}.ID_PRO_HISPROVEEDOR ;;
  }
  dimension: id_pro_hisproveedordef {
    type: number
    sql: ${TABLE}.ID_PRO_HISPROVEEDORDEF ;;
  }
  dimension: id_pro_proveedordevol {
    type: number
    sql: ${TABLE}.ID_PRO_PROVEEDORDEVOL ;;
  }
  dimension: id_pro_razonsocial_dev {
    type: number
    sql: ${TABLE}.ID_PRO_RAZONSOCIAL_DEV ;;
  }
  dimension: id_stk_motivo_stockciclico {
    type: number
    sql: ${TABLE}.ID_STK_MOTIVO_STOCKCICLICO ;;
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
  dimension: id_tkt_tipocomprobante {
    type: number
    sql: ${TABLE}.ID_TKT_TIPOCOMPROBANTE ;;
  }
  measure: count {
    type: count
  }
}
