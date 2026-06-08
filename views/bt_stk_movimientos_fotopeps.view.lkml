view: bt_stk_movimientos_fotopeps {
  sql_table_name: `bss_oracle.BT_STK_MOVIMIENTOS_FOTOPEPS` ;;

  dimension: fc_mov_cantidad {
    type: number
    sql: ${TABLE}.FC_MOV_CANTIDAD ;;
  }
  dimension: fc_mov_cantidadremanente {
    type: number
    sql: ${TABLE}.FC_MOV_CANTIDADREMANENTE ;;
  }
  dimension: fc_mov_costoremanente {
    type: number
    sql: ${TABLE}.FC_MOV_COSTOREMANENTE ;;
  }
  dimension: fc_mov_costototal {
    type: number
    sql: ${TABLE}.FC_MOV_COSTOTOTAL ;;
  }
  dimension: fc_mov_costounitario {
    type: number
    sql: ${TABLE}.FC_MOV_COSTOUNITARIO ;;
  }
  dimension: fc_stk_diasdesdeingreso {
    type: number
    sql: ${TABLE}.FC_STK_DIASDESDEINGRESO ;;
  }
  dimension: fc_stk_stockactual {
    type: number
    sql: ${TABLE}.FC_STK_STOCKACTUAL ;;
  }
  dimension: fl_esfraccionado {
    type: number
    sql: ${TABLE}.FL_ESFRACCIONADO ;;
  }
  dimension: id_art_cuf {
    type: number
    sql: ${TABLE}.ID_ART_CUF ;;
  }
  dimension: id_art_departamento {
    type: number
    sql: ${TABLE}.ID_ART_DEPARTAMENTO ;;
  }
  dimension_group: id_mov_fechahora {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_MOV_FECHAHORA ;;
  }
  dimension: id_suc_empresa {
    type: number
    sql: ${TABLE}.ID_SUC_EMPRESA ;;
  }
  dimension_group: id_tie_dia {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ID_TIE_DIA ;;
  }
  dimension: id_tkt_nrocomprobante {
    type: number
    sql: ${TABLE}.ID_TKT_NROCOMPROBANTE ;;
  }
  dimension: id_tkt_tipocomprobante {
    type: number
    sql: ${TABLE}.ID_TKT_TIPOCOMPROBANTE ;;
  }
  measure: count {
    type: count
  }
}
