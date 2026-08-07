view: bas_dim_categoria {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_categoria` ;;
  fields_hidden_by_default: yes

  dimension: cd_categoria {
    type: string
    sql: ${TABLE}.cd_categoria ;;
  }
  dimension: cd_mayorista {
    type: string
    sql: ${TABLE}.cd_mayorista ;;
  }
  dimension: dsc_categoria {
    type: string
    sql: ${TABLE}.dsc_categoria ;;
  }
  dimension: id_categoria {
    type: number
    sql: ${TABLE}.id_categoria ;;
  }
  dimension: id_departamento {
    type: number
    sql: ${TABLE}.id_departamento ;;
  }
  measure: count {
    type: count
  }
}
