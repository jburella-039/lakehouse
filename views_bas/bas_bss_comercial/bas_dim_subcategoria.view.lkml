view: bas_dim_subcategoria {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_subcategoria` ;;
  fields_hidden_by_default: yes

  dimension: cd_subcategoria {
    type: string
    sql: ${TABLE}.cd_subcategoria ;;
  }
  dimension: dsc_subcategoria {
    type: string
    sql: ${TABLE}.dsc_subcategoria ;;
  }
  dimension: id_categoria {
    type: number
    sql: ${TABLE}.id_categoria ;;
  }
  dimension: id_subcategoria {
    type: number
    sql: ${TABLE}.id_subcategoria ;;
  }
  measure: count {
    type: count
  }
}
