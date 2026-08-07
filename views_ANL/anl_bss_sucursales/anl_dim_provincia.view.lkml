include: "/views_BAS/bas_bss_sucursales/bas_dim_provincia.view.lkml"

view: anl_dim_provincia {
  extends: [bas_dim_provincia]

  dimension: id_provincia { primary_key: yes  hidden: yes }

  dimension: provincia {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_provincia ;;
    label: "Provincia"
  }
}
