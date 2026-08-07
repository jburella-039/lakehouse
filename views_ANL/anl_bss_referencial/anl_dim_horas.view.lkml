include: "/views_BAS/bas_bss_referencial/bas_dim_horas.view.lkml"

view: anl_dim_horas {
  extends: [bas_dim_horas]

  dimension: fec_idhora { primary_key: yes  hidden: no  label: "Hora ID" }

  dimension: hora {
    hidden: no
    type: number
    sql: ${TABLE}.num_hora ;;
    label: "Hora"
  }
  dimension: minuto {
    hidden: no
    type: number
    sql: ${TABLE}.num_minuto ;;
    label: "Minuto"
  }
  dimension: segundo {
    hidden: no
    type: number
    sql: ${TABLE}.num_segundo ;;
    label: "Segundo"
  }
  dimension: hora_desc {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_hora ;;
    label: "Hora (desc)"
  }
  dimension: hora_completa {
    hidden: no
    type: string
    sql: ${TABLE}.fec_horacompleta ;;
    label: "Hora Completa"
  }
  dimension: tramo_horario {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_tramohorario ;;
    label: "Tramo Horario"
  }
  dimension: es_hora_pico {
    hidden: no
    type: yesno
    sql: ${TABLE}.flg_horapico ;;
    label: "Hora Pico?"
  }
  dimension: hora_laboral {
    hidden: no
    type: string
    sql: ${TABLE}.flg_horalaboral ;;
    label: "Hora Laboral"
  }
}
