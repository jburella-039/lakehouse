include: "/views_BAS/bas_bss_referencial/bas_dim_fecha.view.lkml"

view: anl_dim_fecha {
  extends: [bas_dim_fecha]

  dimension: fec_fechaid { primary_key: yes  hidden: yes }

  dimension_group: fecha {
    hidden: no
    type: time
    datatype: date
    convert_tz: no
    timeframes: [raw, date, week, month, month_name, quarter, year]
    sql: ${TABLE}.fec_fecha ;;
    label: "Fecha"
  }

  dimension: anio {
    hidden: no
    type: number
    sql: ${TABLE}.num_anio ;;
    label: "Año"
  }

  dimension: anio_sel {
    hidden: no
    type: string
    sql: CAST(${TABLE}.num_anio AS STRING) ;;
    label: "Año"
    suggestions: ["2026", "2025", "2024"]
  }

  dimension: mes_num {
    hidden: no
    type: number
    sql: ${TABLE}.num_mes ;;
    label: "Mes (num)"
  }

  dimension: mes_nombre {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_mes ;;
    label: "Mes"
  }

  dimension: aniomes {
    hidden: no
    type: string
    sql: ${TABLE}.fec_aniomes ;;
    label: "Año-Mes"
  }

  dimension: trimestre {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_trimestre ;;
    label: "Trimestre"
  }

  dimension: dia_semana {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_diasemana ;;
    label: "Dia de Semana"
  }

  dimension: es_finde {
    hidden: no
    type: yesno
    sql: ${TABLE}.flg_findesemana ;;
    label: "Fin de Semana?"
  }

  dimension: es_dia_habil {
    hidden: no
    type: yesno
    sql: ${TABLE}.flg_esdiahabil ;;
    label: "Dia Habil?"
  }

  dimension: es_mes_actual {
    hidden: no
    type: yesno
    sql: ${TABLE}.flg_mesactual ;;
    label: "Mes Actual?"
  }

  dimension: es_anio_actual {
    hidden: no
    type: yesno
    sql: ${TABLE}.flg_anioactual ;;
    label: "Año Actual?"
  }

  set: detalle {
    fields: [fecha_date, anio, mes_nombre, trimestre, dia_semana]
  }
}
