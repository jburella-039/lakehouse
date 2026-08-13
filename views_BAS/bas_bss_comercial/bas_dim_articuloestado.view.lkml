view: bas_dim_articuloestado {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_articuloestado` ;;
  fields_hidden_by_default: yes
  dimension: cd_articuloestado {
    type: string
    sql: ${TABLE}.cd_articuloestado ;;
  }
  dimension: dsc_articuloestado {
    type: string
    sql: ${TABLE}.dsc_articuloestado ;;
  }
  dimension: dsc_color {
    type: number
    sql: ${TABLE}.dsc_color ;;
  }
  dimension: flg_activo {
    type: number
    sql: ${TABLE}.flg_activo ;;
  }
  dimension: id_articuloestado {
    type: number
    sql: ${TABLE}.id_articuloestado ;;
  }
  measure: count {
    type: count
  }
}
