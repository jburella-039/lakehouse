include: "/views_BAS/bas_bss_salud/bas_dim_obrasocial.view.lkml"

view: anl_dim_obrasocial {
  extends: [bas_dim_obrasocial]

  dimension: id_obrasocial { primary_key: yes  hidden: yes }

  dimension: obrasocial {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_obrasocial ;;
    label: "Obra Social"
  }

  dimension: es_coseguro {
    hidden: no
    type: yesno
    sql: ${TABLE}.flg_escoseguro = 1 ;;
    label: "Es Coseguro?"
  }
}
