view: bas_dim_fecha {
  sql_table_name: `lakehouse-dev-483619.bss_referencial.dim_fecha` ;;
  fields_hidden_by_default: yes

  dimension: dsc_diasemana {
    type: string
    sql: ${TABLE}.dsc_diasemana ;;
  }
  dimension: dsc_mes {
    type: string
    sql: ${TABLE}.dsc_mes ;;
  }
  dimension: dsc_trimestre {
    type: string
    sql: ${TABLE}.dsc_trimestre ;;
  }
  dimension: fec_aniomes {
    type: string
    sql: ${TABLE}.fec_aniomes ;;
  }
  dimension_group: fec_fecha {
    type: time
    datatype: date
    convert_tz: no
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_fecha ;;
  }
  dimension: fec_fechaid {
    type: number
    sql: ${TABLE}.fec_fechaid ;;
  }
  dimension_group: fec_finanio {
    type: time
    datatype: date
    convert_tz: no
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_finanio ;;
  }
  dimension_group: fec_finmes {
    type: time
    datatype: date
    convert_tz: no
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_finmes ;;
  }
  dimension_group: fec_finsemana {
    type: time
    datatype: date
    convert_tz: no
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_finsemana ;;
  }
  dimension_group: fec_fintrimestre {
    type: time
    datatype: date
    convert_tz: no
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_fintrimestre ;;
  }
  dimension_group: fec_inicioanio {
    type: time
    datatype: date
    convert_tz: no
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_inicioanio ;;
  }
  dimension_group: fec_iniciomes {
    type: time
    datatype: date
    convert_tz: no
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_iniciomes ;;
  }
  dimension_group: fec_iniciosemana {
    type: time
    datatype: date
    convert_tz: no
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_iniciosemana ;;
  }
  dimension_group: fec_iniciotrimestre {
    type: time
    datatype: date
    convert_tz: no
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_iniciotrimestre ;;
  }
  dimension: fec_semanaiso {
    type: string
    sql: ${TABLE}.fec_semanaiso ;;
  }
  dimension: flg_anioactual {
    type: yesno
    sql: ${TABLE}.flg_anioactual ;;
  }
  dimension: flg_esdiahabil {
    type: yesno
    sql: ${TABLE}.flg_esdiahabil ;;
  }
  dimension: flg_findesemana {
    type: yesno
    sql: ${TABLE}.flg_findesemana ;;
  }
  dimension: flg_mesactual {
    type: yesno
    sql: ${TABLE}.flg_mesactual ;;
  }
  dimension: num_anio {
    type: number
    sql: ${TABLE}.num_anio ;;
  }
  dimension: num_dia {
    type: number
    sql: ${TABLE}.num_dia ;;
  }
  dimension: num_diasemana {
    type: number
    sql: ${TABLE}.num_diasemana ;;
  }
  dimension: num_mes {
    type: number
    sql: ${TABLE}.num_mes ;;
  }
  dimension: num_semanaanio {
    type: number
    sql: ${TABLE}.num_semanaanio ;;
  }
  dimension: num_trimestre {
    type: number
    sql: ${TABLE}.num_trimestre ;;
  }
  measure: count {
    type: count
  }
}
