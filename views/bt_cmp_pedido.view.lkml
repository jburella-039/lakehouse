view: bt_cmp_pedido {
  sql_table_name: `bss_oracle.BT_CMP_PEDIDO` ;;

  dimension: fc_ped_bultos {
    type: number
    sql: ${TABLE}.FC_PED_BULTOS ;;
  }
  dimension: fc_ped_cantidad {
    type: number
    sql: ${TABLE}.FC_PED_CANTIDAD ;;
  }
  dimension: fc_ped_cantidadasignada {
    type: number
    sql: ${TABLE}.FC_PED_CANTIDADASIGNADA ;;
  }
  dimension: fc_ped_cantidaditemsasignados {
    type: number
    sql: ${TABLE}.FC_PED_CANTIDADITEMSASIGNADOS ;;
  }
  dimension: fc_ped_cantidaditemspedido {
    type: number
    sql: ${TABLE}.FC_PED_CANTIDADITEMSPEDIDO ;;
  }
  dimension: fc_ped_cantidaditemspreparada {
    type: number
    sql: ${TABLE}.FC_PED_CANTIDADITEMSPREPARADA ;;
  }
  dimension: fc_ped_cantidadpreparada {
    type: number
    sql: ${TABLE}.FC_PED_CANTIDADPREPARADA ;;
  }
  dimension: fc_ped_cantidadsugerida {
    type: number
    sql: ${TABLE}.FC_PED_CANTIDADSUGERIDA ;;
  }
  dimension: fc_ped_costo {
    type: number
    sql: ${TABLE}.FC_PED_COSTO ;;
  }
  dimension: fc_ped_pedidoanterior {
    type: number
    sql: ${TABLE}.FC_PED_PEDIDOANTERIOR ;;
  }
  dimension: fc_ped_promedio {
    type: number
    sql: ${TABLE}.FC_PED_PROMEDIO ;;
  }
  dimension: fc_ped_stock {
    type: number
    sql: ${TABLE}.FC_PED_STOCK ;;
  }
  dimension: fc_ped_stockcdf {
    type: number
    sql: ${TABLE}.FC_PED_STOCKCDF ;;
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
  dimension: id_etl_cargadatos {
    type: number
    sql: ${TABLE}.ID_ETL_CARGADATOS ;;
  }
  dimension: id_msk_nrocomprobante {
    type: number
    sql: ${TABLE}.ID_MSK_NROCOMPROBANTE ;;
  }
  dimension: id_ped_espsicotropico {
    type: number
    sql: ${TABLE}.ID_PED_ESPSICOTROPICO ;;
  }
  dimension: id_ped_estadopedidoscdf {
    type: number
    sql: ${TABLE}.ID_PED_ESTADOPEDIDOSCDF ;;
  }
  dimension_group: id_ped_fum {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_PED_FUM ;;
  }
  dimension: id_ped_nropedido {
    type: number
    sql: ${TABLE}.ID_PED_NROPEDIDO ;;
  }
  dimension: id_ped_sucursaldestino {
    type: number
    sql: ${TABLE}.ID_PED_SUCURSALDESTINO ;;
  }
  dimension: id_ped_tipopedido {
    type: number
    sql: ${TABLE}.ID_PED_TIPOPEDIDO ;;
  }
  dimension: id_ped_tipoprioridad {
    type: number
    sql: ${TABLE}.ID_PED_TIPOPRIORIDAD ;;
  }
  dimension: id_pkl_nropickeo {
    type: number
    sql: ${TABLE}.ID_PKL_NROPICKEO ;;
  }
  dimension: id_pkl_nropickinglist {
    type: number
    sql: ${TABLE}.ID_PKL_NROPICKINGLIST ;;
  }
  dimension: id_pro_hisproveedor {
    type: number
    sql: ${TABLE}.ID_PRO_HISPROVEEDOR ;;
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
  dimension_group: id_tie_fechaasignacion {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_TIE_FECHAASIGNACION ;;
  }
  dimension_group: id_tie_fechaultimamodificacion_dw {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_TIE_FECHAULTIMAMODIFICACION_DW ;;
  }
  measure: count {
    type: count
  }
}
