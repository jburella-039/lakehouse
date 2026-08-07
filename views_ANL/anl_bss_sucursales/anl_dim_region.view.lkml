include: "/views_BAS/bas_bss_sucursales/bas_dim_region.view.lkml"

view: anl_dim_region {
  extends: [bas_dim_region]

  dimension: id_region { primary_key: yes  hidden: yes }

  dimension: region {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_region ;;
    label: "Region"
  }
}
