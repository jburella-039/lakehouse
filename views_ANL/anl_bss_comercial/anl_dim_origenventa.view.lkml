include: "/views_BAS/bas_bss_comercial/bas_dim_origenventa.view.lkml"

view: anl_dim_origenventa {
  extends: [bas_dim_origenventa]

  dimension: id_origenventa { primary_key: yes  hidden: yes }

  dimension: canal {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_origenventa ;;
    label: "Canal"
  }

  dimension: es_presencial {
    hidden: no
    type: yesno
    sql: ${TABLE}.flg_espresencial = 1 ;;
    label: "Es Presencial?"
  }

  dimension: presencialidad {
    hidden: no
    type: string
    sql: CASE WHEN ${TABLE}.flg_espresencial = 1 THEN 'Presencial' ELSE 'No Presencial' END ;;
    label: "Presencial / No Presencial"
  }
}
