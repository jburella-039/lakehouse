view: bas_dim_provincia {
  sql_table_name: `lakehouse-dev-483619.bss_sucursales.dim_provincia` ;;
  fields_hidden_by_default: yes

  dimension: dsc_provincia {
    type: string
    sql: ${TABLE}.dsc_provincia ;;
  }
  dimension: id_pais {
    type: number
    sql: ${TABLE}.id_pais ;;
  }
  dimension: id_provincia {
    type: number
    sql: ${TABLE}.id_provincia ;;
  }
  dimension: pct_iibb {
    type: number
    sql: ${TABLE}.pct_iibb ;;
  }
  measure: count {
    type: count
  }
}
