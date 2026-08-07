include: "/views_BAS/bas_bss_comercial/bas_dim_subcategoria.view.lkml"

view: anl_dim_subcategoria {
  extends: [bas_dim_subcategoria]

  dimension: id_subcategoria { primary_key: yes  hidden: yes }

  dimension: subcategoria {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_subcategoria ;;
    label: "Subcategoria"
  }
}
