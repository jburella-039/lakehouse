view: bt_ped_drogexterna {
  sql_table_name: `bss_oracle.BT_PED_DROGEXTERNA` ;;

  dimension: fc_ped_cantagregada {
    type: number
    sql: ${TABLE}.FC_PED_CANTAGREGADA ;;
  }
  dimension: fc_ped_cantpedida {
    type: number
    sql: ${TABLE}.FC_PED_CANTPEDIDA ;;
  }
  dimension: fc_ped_cantprometida {
    type: number
    sql: ${TABLE}.FC_PED_CANTPROMETIDA ;;
  }
  dimension: fc_ped_cantsugerida {
    type: number
    sql: ${TABLE}.FC_PED_CANTSUGERIDA ;;
  }
  dimension: id_art_cuf {
    type: number
    sql: ${TABLE}.ID_ART_CUF ;;
  }
  dimension: id_ped_cambiaronsugerido {
    type: number
    sql: ${TABLE}.ID_PED_CAMBIARONSUGERIDO ;;
  }
  dimension: id_ped_esitemagregado {
    type: number
    sql: ${TABLE}.ID_PED_ESITEMAGREGADO ;;
  }
  dimension: id_ped_espsicotropico {
    type: number
    sql: ${TABLE}.ID_PED_ESPSICOTROPICO ;;
  }
  dimension: id_ped_manual {
    type: number
    sql: ${TABLE}.ID_PED_MANUAL ;;
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
  measure: count {
    type: count
  }
}
