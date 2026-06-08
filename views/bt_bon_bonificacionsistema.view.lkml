view: bt_bon_bonificacionsistema {
  sql_table_name: `bss_oracle.BT_BON_BONIFICACIONSISTEMA` ;;

  dimension: ds_bon_descripcion {
    type: string
    sql: ${TABLE}.DS_BON_DESCRIPCION ;;
  }
  dimension: ds_bon_observacion {
    type: string
    sql: ${TABLE}.DS_BON_OBSERVACION ;;
  }
  dimension: fc_bon_boniftotal {
    type: number
    sql: ${TABLE}.FC_BON_BONIFTOTAL ;;
  }
  dimension: id_art_hisdepartamento {
    type: number
    sql: ${TABLE}.ID_ART_HISDEPARTAMENTO ;;
  }
  dimension: id_bon_activo {
    type: number
    sql: ${TABLE}.ID_BON_ACTIVO ;;
  }
  dimension: id_bon_bonificacion {
    type: number
    sql: ${TABLE}.ID_BON_BONIFICACION ;;
  }
  dimension: id_bon_bonificaciondoc {
    type: number
    sql: ${TABLE}.ID_BON_BONIFICACIONDOC ;;
  }
  dimension: id_bon_bonifsistema {
    type: number
    sql: ${TABLE}.ID_BON_BONIFSISTEMA ;;
  }
  dimension: id_bon_estadoadm {
    type: number
    sql: ${TABLE}.ID_BON_ESTADOADM ;;
  }
  dimension: id_bon_estadobonif {
    type: number
    sql: ${TABLE}.ID_BON_ESTADOBONIF ;;
  }
  dimension_group: id_bon_fechaalta {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_BON_FECHAALTA ;;
  }
  dimension_group: id_bon_fechaemision {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_BON_FECHAEMISION ;;
  }
  dimension: id_bon_original {
    type: number
    sql: ${TABLE}.ID_BON_ORIGINAL ;;
  }
  dimension: id_dts_empresa {
    type: number
    sql: ${TABLE}.ID_DTS_EMPRESA ;;
  }
  dimension: id_pro_proveedor {
    type: number
    sql: ${TABLE}.ID_PRO_PROVEEDOR ;;
  }
  dimension: id_rrh_empleado {
    type: number
    sql: ${TABLE}.ID_RRH_EMPLEADO ;;
  }
  dimension: id_suc_empresa {
    type: number
    sql: ${TABLE}.ID_SUC_EMPRESA ;;
  }
  dimension: id_suc_sucursal {
    type: number
    sql: ${TABLE}.ID_SUC_SUCURSAL ;;
  }
  dimension: id_tie_mesasignacion {
    type: number
    sql: ${TABLE}.ID_TIE_MESASIGNACION ;;
  }
  dimension: id_tie_mesdtoprovee {
    type: number
    sql: ${TABLE}.ID_TIE_MESDTOPROVEE ;;
  }
  dimension: id_tie_mesregistracion {
    type: number
    sql: ${TABLE}.ID_TIE_MESREGISTRACION ;;
  }
  measure: count {
    type: count
  }
}
