view: bas_dim_horas {
  sql_table_name: `lakehouse-dev-483619.bss_referencial.dim_horas` ;;
  fields_hidden_by_default: yes

  dimension: dsc_hora {
    type: string
    sql: ${TABLE}.dsc_hora ;;
  }
  dimension: dsc_tramohorario {
    type: string
    sql: ${TABLE}.dsc_tramohorario ;;
  }
  dimension: fec_horacompleta {
    type: string
    sql: ${TABLE}.fec_horacompleta ;;
  }
  dimension: fec_idhora {
    type: number
    sql: ${TABLE}.fec_idhora ;;
  }
  dimension: flg_horalaboral {
    type: string
    sql: ${TABLE}.flg_horalaboral ;;
  }
  dimension: flg_horapico {
    type: yesno
    sql: ${TABLE}.flg_horapico ;;
  }
  dimension: num_hora {
    type: number
    sql: ${TABLE}.num_hora ;;
  }
  dimension: num_minuto {
    type: number
    sql: ${TABLE}.num_minuto ;;
  }
  dimension: num_segundo {
    type: number
    sql: ${TABLE}.num_segundo ;;
  }
  measure: count {
    type: count
  }
}
