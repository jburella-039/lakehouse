# =============================================================================
# view: dim_horas
# Dimension de hora del dia. Fuente:
# lakehouse-dev-483619.bss_referencial.dim_horas
#
# NOTA DE GRANO: la dim esta al nivel hora:minuto:segundo (clave fec_idhora),
# mientras que los hechos Venta Integral solo guardan la HORA (num_hora /
# ID_HRS_HORA). Por eso NO se joinea a fct_ventas / fct_remitos: un join por hora
# seria many-to-many e infla las medidas. Queda disponible como vista para
# analisis de hora puntual o para joinear cuando el hecho exponga una clave de
# tiempo completa (HHMMSS).
# =============================================================================

view: dim_horas {
  sql_table_name: `lakehouse-dev-483619.bss_referencial.dim_horas` ;;

  dimension: fec_idhora {
    primary_key: yes
    type: number
    sql: ${TABLE}.fec_idhora ;;
    label: "Hora ID"
  }

  dimension: hora {
    type: number
    sql: ${TABLE}.num_hora ;;
    label: "Hora"
  }

  dimension: minuto {
    type: number
    sql: ${TABLE}.num_minuto ;;
    label: "Minuto"
  }

  dimension: segundo {
    type: number
    sql: ${TABLE}.num_segundo ;;
    label: "Segundo"
  }

  dimension: hora_desc {
    type: string
    sql: ${TABLE}.dsc_hora ;;
    label: "Hora (desc)"
  }

  dimension: hora_completa {
    type: string
    sql: ${TABLE}.fec_horacompleta ;;
    label: "Hora Completa"
  }

  dimension: tramo_horario {
    type: string
    sql: ${TABLE}.dsc_tramohorario ;;
    label: "Tramo Horario"
  }

  dimension: es_hora_pico {
    type: yesno
    sql: ${TABLE}.flg_horapico ;;
    label: "Hora Pico?"
  }

  dimension: hora_laboral {
    type: string
    sql: ${TABLE}.flg_horalaboral ;;
    label: "Hora Laboral"
  }
}
