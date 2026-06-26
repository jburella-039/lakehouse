# =============================================================================
# view: dim_fecha
# Dimension calendario (1 fila por dia, 2015-2050). Fuente:
# lakehouse-dev-483619.bss_referencial.dim_fecha
#
# Se usa como UNICA fuente de fecha de los dashboards Venta Integral. El filtro
# "Fecha" y "Año" apuntan aca (campos DATE puros, sin convert_tz) en vez del
# TIMESTAMP crudo del hecho (fec_dia / ID_TIE_DIA), que arrastraba corrimientos
# por timezone. Join al hecho por DATE(fec_dia) = fec_fecha (validado lossless).
# =============================================================================

view: dim_fecha {
  sql_table_name: `lakehouse-dev-483619.bss_referencial.dim_fecha` ;;

  # Clave surrogada YYYYMMDD (no se muestra; el join real es por fec_fecha DATE).
  dimension: fec_fechaid {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.fec_fechaid ;;
  }

  # Fecha (DATE puro). convert_tz: no -> no corre la fecha por timezone.
  dimension_group: fecha {
    type: time
    datatype: date
    convert_tz: no
    timeframes: [raw, date, week, month, month_name, quarter, year]
    sql: ${TABLE}.fec_fecha ;;
    label: "Fecha"
  }

  # Año numerico (para agregaciones / pivotes).
  dimension: anio {
    type: number
    sql: ${TABLE}.num_anio ;;
    label: "Año"
  }

  # Año como STRING para el filtro selector (dropdown de lista). Un field_filter
  # sobre un numero renderiza un input numerico sin lista; este de texto con
  # suggestions fijas muestra el desplegable con los años.
  dimension: anio_sel {
    type: string
    sql: CAST(${TABLE}.num_anio AS STRING) ;;
    label: "Año"
    suggestions: ["2026", "2025", "2024"]
  }

  dimension: mes_num {
    type: number
    sql: ${TABLE}.num_mes ;;
    label: "Mes (num)"
  }

  dimension: mes_nombre {
    type: string
    sql: ${TABLE}.dsc_mes ;;
    label: "Mes"
  }

  # "2026-03" (mismo formato que el timeframe month de Looker).
  dimension: aniomes {
    type: string
    sql: ${TABLE}.fec_aniomes ;;
    label: "Año-Mes"
  }

  dimension: trimestre {
    type: string
    sql: ${TABLE}.dsc_trimestre ;;
    label: "Trimestre"
  }

  dimension: dia_semana {
    type: string
    sql: ${TABLE}.dsc_diasemana ;;
    label: "Dia de Semana"
  }

  dimension: es_finde {
    type: yesno
    sql: ${TABLE}.flg_findesemana ;;
    label: "Fin de Semana?"
  }

  dimension: es_dia_habil {
    type: yesno
    sql: ${TABLE}.flg_esdiahabil ;;
    label: "Dia Habil?"
  }

  dimension: es_mes_actual {
    type: yesno
    sql: ${TABLE}.flg_mesactual ;;
    label: "Mes Actual?"
  }

  dimension: es_anio_actual {
    type: yesno
    sql: ${TABLE}.flg_anioactual ;;
    label: "Año Actual?"
  }

  set: detalle {
    fields: [fecha_date, anio, mes_nombre, trimestre, dia_semana]
  }
}
