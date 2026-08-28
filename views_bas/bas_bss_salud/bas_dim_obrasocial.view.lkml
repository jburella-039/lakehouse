view: bas_dim_obrasocial {
  sql_table_name: `lakehouse-dev-483619.bss_salud.dim_obrasocial` ;;
  fields_hidden_by_default: yes

  dimension: cd_obrasocial {
    type: string
    sql: ${TABLE}.cd_obrasocial ;;
  }
  dimension: cd_padreobrasocial {
    type: string
    sql: ${TABLE}.cd_padreobrasocial ;;
  }
  dimension: dsc_obrasocial {
    type: string
    sql: ${TABLE}.dsc_obrasocial ;;
  }
  dimension: flg_activa {
    type: string
    sql: ${TABLE}.flg_activa ;;
  }
  dimension: flg_dtodirecto {
    type: number
    sql: ${TABLE}.flg_dtodirecto ;;
  }
  dimension: flg_dtolaboratorio {
    type: number
    sql: ${TABLE}.flg_dtolaboratorio ;;
  }
  dimension: flg_escoseguro {
    type: number
    sql: ${TABLE}.flg_escoseguro ;;
  }
  dimension: flg_espromocion {
    type: number
    sql: ${TABLE}.flg_espromocion ;;
  }
  dimension: flg_tratamientocompartido {
    type: number
    sql: ${TABLE}.flg_tratamientocompartido ;;
  }
  dimension: id_empresa {
    type: number
    sql: ${TABLE}.id_empresa ;;
  }
  dimension: id_grupoos {
    type: number
    sql: ${TABLE}.id_grupoos ;;
  }
  dimension: id_mandataria {
    type: number
    sql: ${TABLE}.id_mandataria ;;
  }
  dimension: id_obrasocial {
    type: number
    sql: ${TABLE}.id_obrasocial ;;
  }
  dimension: id_obrasocialtipoplan {
    type: number
    sql: ${TABLE}.id_obrasocialtipoplan ;;
  }
  dimension: id_tipocobertura {
    type: number
    sql: ${TABLE}.id_tipocobertura ;;
  }
  measure: count {
    type: count
  }
}
