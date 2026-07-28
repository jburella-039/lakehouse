# =============================================================================
# RAW view: raw_dim_fecha
# Capa CRUDA (mirror del origen, sin logica de negocio).
# Fuente: lakehouse-dev-483619.bss_referencial.dim_fecha
# Todos los campos ocultos por defecto (fields_hidden_by_default). La capa STG
# (dim_fecha) los expone con hidden: no y agrega la semantica de negocio.
# =============================================================================

view: raw_dim_fecha {
  sql_table_name: `lakehouse-dev-483619.bss_referencial.dim_fecha` ;;
  fields_hidden_by_default: yes

  # Clave surrogada YYYYMMDD (el join real es por fecha_date DATE).
  dimension: fec_fechaid {
    primary_key: yes
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

  dimension: anio { type: number sql: ${TABLE}.num_anio ;; label: "Año" }

  # Año como STRING para el filtro selector (dropdown de lista).
  dimension: anio_sel {
    type: string
    sql: CAST(${TABLE}.num_anio AS STRING) ;;
    label: "Año"
    suggestions: ["2026", "2025", "2024"]
  }

  dimension: mes_num    { type: number sql: ${TABLE}.num_mes ;;        label: "Mes (num)" }
  dimension: mes_nombre { type: string sql: ${TABLE}.dsc_mes ;;        label: "Mes" }
  dimension: aniomes    { type: string sql: ${TABLE}.fec_aniomes ;;    label: "Año-Mes" }
  dimension: trimestre  { type: string sql: ${TABLE}.dsc_trimestre ;;  label: "Trimestre" }
  dimension: dia_semana { type: string sql: ${TABLE}.dsc_diasemana ;;  label: "Dia de Semana" }

  dimension: es_finde       { type: yesno sql: ${TABLE}.flg_findesemana ;; label: "Fin de Semana?" }
  dimension: es_dia_habil   { type: yesno sql: ${TABLE}.flg_esdiahabil ;;  label: "Dia Habil?" }
  dimension: es_mes_actual  { type: yesno sql: ${TABLE}.flg_mesactual ;;   label: "Mes Actual?" }
  dimension: es_anio_actual { type: yesno sql: ${TABLE}.flg_anioactual ;;  label: "Año Actual?" }
}
