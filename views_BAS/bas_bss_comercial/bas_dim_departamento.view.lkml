view: bas_dim_departamento {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_departamento` ;;
  fields_hidden_by_default: yes

  dimension: cd_departamento {
    type: string
    sql: ${TABLE}.cd_departamento ;;
  }
  dimension: cd_mayorista {
    type: string
    sql: ${TABLE}.cd_mayorista ;;
  }
  dimension: dsc_departamento {
    type: string
    sql: ${TABLE}.dsc_departamento ;;
  }
  dimension: flg_activo {
    type: yesno
    sql: ${TABLE}.flg_activo ;;
  }
  dimension: flg_pdvf {
    type: yesno
    sql: ${TABLE}.flg_pdvf ;;
  }
  dimension: id_departamento {
    type: number
    sql: ${TABLE}.id_departamento ;;
  }
  dimension: id_nroorden {
    type: number
    sql: ${TABLE}.id_nroorden ;;
  }
  dimension: id_operacioncomercial {
    type: number
    sql: ${TABLE}.id_operacioncomercial ;;
  }
  measure: count {
    type: count
  }
}
