view: bas_dim_marca {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_marca` ;;
  fields_hidden_by_default: yes

  dimension: cd_marca {
    type: string
    sql: ${TABLE}.cd_marca ;;
  }
  dimension: dsc_marca {
    type: string
    sql: ${TABLE}.dsc_marca ;;
  }
  dimension: flg_eslaboratorio {
    type: yesno
    sql: ${TABLE}.flg_eslaboratorio ;;
  }
  dimension: flg_trabajagenericos {
    type: yesno
    sql: ${TABLE}.flg_trabajagenericos ;;
  }
  dimension: id_marca {
    type: number
    sql: ${TABLE}.id_marca ;;
  }
  measure: count {
    type: count
  }
}
