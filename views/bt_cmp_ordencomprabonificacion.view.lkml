view: bt_cmp_ordencomprabonificacion {
  sql_table_name: `bss_oracle.BT_CMP_ORDENCOMPRABONIFICACION` ;;

  dimension: ds_odc_observciones {
    type: string
    sql: ${TABLE}.DS_ODC_OBSERVCIONES ;;
  }
  dimension: fc_idr_bonifmercaderia {
    type: number
    value_format_name: id
    sql: ${TABLE}.FC_IDR_BONIFMERCADERIA ;;
  }
  dimension: fc_idr_bonifparticular {
    type: number
    value_format_name: id
    sql: ${TABLE}.FC_IDR_BONIFPARTICULAR ;;
  }
  dimension: fc_idr_bonifporcenfact {
    type: number
    value_format_name: id
    sql: ${TABLE}.FC_IDR_BONIFPORCENFACT ;;
  }
  dimension: fc_idr_bonifporcncd {
    type: number
    value_format_name: id
    sql: ${TABLE}.FC_IDR_BONIFPORCNCD ;;
  }
  dimension: fc_idr_porcbonificacion {
    type: number
    value_format_name: id
    sql: ${TABLE}.FC_IDR_PORCBONIFICACION ;;
  }
  dimension: fc_idr_porcfact {
    type: number
    value_format_name: id
    sql: ${TABLE}.FC_IDR_PORCFACT ;;
  }
  dimension: fc_idr_porcncd {
    type: number
    value_format_name: id
    sql: ${TABLE}.FC_IDR_PORCNCD ;;
  }
  dimension: fc_idr_totalremitido {
    type: number
    value_format_name: id
    sql: ${TABLE}.FC_IDR_TOTALREMITIDO ;;
  }
  dimension: fc_odc_bonifmercaderia {
    type: number
    sql: ${TABLE}.FC_ODC_BONIFMERCADERIA ;;
  }
  dimension: fc_odc_bonifparticular {
    type: number
    sql: ${TABLE}.FC_ODC_BONIFPARTICULAR ;;
  }
  dimension: fc_odc_bonifporcenfact {
    type: number
    sql: ${TABLE}.FC_ODC_BONIFPORCENFACT ;;
  }
  dimension: fc_odc_bonifporcncd {
    type: number
    sql: ${TABLE}.FC_ODC_BONIFPORCNCD ;;
  }
  dimension: fc_odc_porcbonificacion {
    type: number
    sql: ${TABLE}.FC_ODC_PORCBONIFICACION ;;
  }
  dimension: fc_odc_porcfact {
    type: number
    sql: ${TABLE}.FC_ODC_PORCFACT ;;
  }
  dimension: fc_odc_porcncd {
    type: number
    sql: ${TABLE}.FC_ODC_PORCNCD ;;
  }
  dimension: fc_odc_totalremitido {
    type: number
    sql: ${TABLE}.FC_ODC_TOTALREMITIDO ;;
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
  dimension: id_etl_cargadatos {
    type: number
    sql: ${TABLE}.ID_ETL_CARGADATOS ;;
  }
  dimension: id_idr_nroinforme {
    type: number
    value_format_name: id
    sql: ${TABLE}.ID_IDR_NROINFORME ;;
  }
  dimension: id_irt_tipoinformerecepcion {
    type: number
    sql: ${TABLE}.ID_IRT_TIPOINFORMERECEPCION ;;
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
  dimension: id_pro_hisproveedor {
    type: number
    sql: ${TABLE}.ID_PRO_HISPROVEEDOR ;;
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
