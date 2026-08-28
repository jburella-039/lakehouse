include: "/views_bas/bas_bss_comercial/bas_dim_marca.view.lkml"

view: anl_dim_marca {
  extends: [bas_dim_marca]

  dimension: id_marca { primary_key: yes  hidden: yes }

  dimension: marca {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_marca ;;
    label: "Marca"
  }

  dimension: es_laboratorio {
    hidden: no
    type: yesno
    sql: ${TABLE}.flg_eslaboratorio ;;
    label: "Es Laboratorio?"
  }
}
