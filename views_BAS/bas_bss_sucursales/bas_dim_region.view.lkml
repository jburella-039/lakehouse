view: bas_dim_region {
  sql_table_name: `lakehouse-dev-483619.bss_sucursales.dim_region` ;;
  fields_hidden_by_default: yes

  dimension: dsc_region {
    type: string
    sql: ${TABLE}.dsc_region ;;
  }
  dimension: id_region {
    type: number
    sql: ${TABLE}.id_region ;;
  }
  dimension: id_zona {
    type: number
    sql: ${TABLE}.id_zona ;;
  }
  measure: count {
    type: count
  }
}
