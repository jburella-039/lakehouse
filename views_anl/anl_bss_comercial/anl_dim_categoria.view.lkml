include: "/views_bas/bas_bss_comercial/bas_dim_categoria.view.lkml"

view: anl_dim_categoria {
  extends: [bas_dim_categoria]

  dimension: id_categoria {
    primary_key: yes
    hidden: yes
  }

  dimension: categoria {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_categoria ;;
    label: "Categoria"
  }
}
