view: bt_cmp_ordencomprabonificada {
  sql_table_name: `bss_oracle.BT_CMP_ORDENCOMPRABONIFICADA` ;;

  dimension: ds_odc_observciones {
    type: string
    sql: ${TABLE}.DS_ODC_OBSERVCIONES ;;
  }
  dimension: fc_odc_porcentajebonificacion {
    type: number
    sql: ${TABLE}.FC_ODC_PORCENTAJEBONIFICACION ;;
  }
  dimension: id_bon_bonificacion {
    type: number
    sql: ${TABLE}.ID_BON_BONIFICACION ;;
  }
  dimension: id_bon_bonificaciondoc {
    type: number
    sql: ${TABLE}.ID_BON_BONIFICACIONDOC ;;
  }
  dimension: id_bon_tipo {
    type: number
    sql: ${TABLE}.ID_BON_TIPO ;;
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
  dimension_group: id_odc_fum {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_ODC_FUM ;;
  }
  dimension: id_odc_ordendecompra {
    type: number
    sql: ${TABLE}.ID_ODC_ORDENDECOMPRA ;;
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
