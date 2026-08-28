view: bas_dim_origenventa {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_origenventa` ;;
  fields_hidden_by_default: yes

  dimension: dsc_origenventa {
    type: string
    sql: ${TABLE}.dsc_origenventa ;;
  }
  dimension: flg_espresencial {
    type: number
    sql: ${TABLE}.flg_espresencial ;;
  }
  dimension: flg_requiereinfoposventa {
    type: number
    sql: ${TABLE}.flg_requiereinfoposventa ;;
  }
  dimension: id_origenventa {
    type: number
    sql: ${TABLE}.id_origenventa ;;
  }
  measure: count {
    type: count
  }
}
