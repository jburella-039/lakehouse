view: bt_cmp_ordencompra {
  sql_table_name: `bss_oracle.BT_CMP_ORDENCOMPRA` ;;

  dimension: fc_odc_bulto {
    type: number
    sql: ${TABLE}.FC_ODC_BULTO ;;
  }
  dimension: fc_odc_cantidadbonificada {
    type: number
    sql: ${TABLE}.FC_ODC_CANTIDADBONIFICADA ;;
  }
  dimension: fc_odc_cantidadpedida {
    type: number
    sql: ${TABLE}.FC_ODC_CANTIDADPEDIDA ;;
  }
  dimension: fc_odc_cantidadpisoporpalet {
    type: number
    sql: ${TABLE}.FC_ODC_CANTIDADPISOPORPALET ;;
  }
  dimension: fc_odc_cantidadpromedio {
    type: number
    sql: ${TABLE}.FC_ODC_CANTIDADPROMEDIO ;;
  }
  dimension: fc_odc_cantidadremitida {
    type: number
    sql: ${TABLE}.FC_ODC_CANTIDADREMITIDA ;;
  }
  dimension: fc_odc_porcbonifparticular {
    type: number
    sql: ${TABLE}.FC_ODC_PORCBONIFPARTICULAR ;;
  }
  dimension: fc_odc_preciolista {
    type: number
    sql: ${TABLE}.FC_ODC_PRECIOLISTA ;;
  }
  dimension: fc_odc_preciounitario {
    type: number
    sql: ${TABLE}.FC_ODC_PRECIOUNITARIO ;;
  }
  dimension: fc_odc_stockalmomento {
    type: number
    sql: ${TABLE}.FC_ODC_STOCKALMOMENTO ;;
  }
  dimension: fc_odc_ubf {
    type: number
    sql: ${TABLE}.FC_ODC_UBF ;;
  }
  dimension: fc_odc_upp {
    type: number
    sql: ${TABLE}.FC_ODC_UPP ;;
  }
  dimension: id_art_cuf {
    type: number
    sql: ${TABLE}.ID_ART_CUF ;;
  }
  dimension: id_cdp_condicionpago {
    type: number
    sql: ${TABLE}.ID_CDP_CONDICIONPAGO ;;
  }
  dimension: id_eoc_estadoordcmp {
    type: number
    sql: ${TABLE}.ID_EOC_ESTADOORDCMP ;;
  }
  dimension: id_etl_cargadatos {
    type: number
    sql: ${TABLE}.ID_ETL_CARGADATOS ;;
  }
  dimension: id_mod_origendato {
    type: number
    sql: ${TABLE}.ID_MOD_ORIGENDATO ;;
  }
  dimension_group: id_odc_diaentregacdf {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_ODC_DIAENTREGACDF ;;
  }
  dimension: id_odc_escondicdepagopordefec {
    type: number
    sql: ${TABLE}.ID_ODC_ESCONDICDEPAGOPORDEFEC ;;
  }
  dimension_group: id_odc_fum {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_ODC_FUM ;;
  }
  dimension: id_odc_ordendecompra {
    type: number
    sql: ${TABLE}.ID_ODC_ORDENDECOMPRA ;;
  }
  dimension: id_odc_sucursaldestino {
    type: number
    sql: ${TABLE}.ID_ODC_SUCURSALDESTINO ;;
  }
  dimension: id_ped_nropedidosucursal {
    type: number
    sql: ${TABLE}.ID_PED_NROPEDIDOSUCURSAL ;;
  }
  dimension: id_pro_proveedor {
    type: number
    sql: ${TABLE}.ID_PRO_PROVEEDOR ;;
  }
  dimension: id_rrh_empleado {
    type: number
    sql: ${TABLE}.ID_RRH_EMPLEADO ;;
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
  dimension: id_tie_mes {
    type: number
    sql: ${TABLE}.ID_TIE_MES ;;
  }
  measure: count {
    type: count
  }
}
