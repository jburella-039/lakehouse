view: bas_dim_formato {
  sql_table_name: `lakehouse-dev-483619.bss_sucursales.dim_formato` ;;
  fields_hidden_by_default: yes

  dimension: cd_formato {
    type: string
    sql: ${TABLE}.cd_formato ;;
  }
  dimension: dsc_formato {
    type: string
    sql: ${TABLE}.dsc_formato ;;
  }
  dimension: flg_activoformato {
    type: yesno
    sql: ${TABLE}.flg_activoformato ;;
  }
  dimension: id_formato {
    type: number
    sql: ${TABLE}.id_formato ;;
  }
  dimension: id_formatopadre {
    type: number
    sql: ${TABLE}.id_formatopadre ;;
  }
  measure: count {
    type: count
  }
}
