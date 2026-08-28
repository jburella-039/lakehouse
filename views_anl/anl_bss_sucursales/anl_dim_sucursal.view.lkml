include: "/views_bas/bas_bss_sucursales/bas_dim_sucursal.view.lkml"

view: anl_dim_sucursal {
  extends: [bas_dim_sucursal]

  dimension: id_sucursal { primary_key: yes  hidden: no  label: "Sucursal (ID)" }
  dimension: cd_sucursal { hidden: no  label: "Sucursal (codigo)" }

  dimension: sucursal {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_sucursal ;;
    label: "Sucursal"
  }
  dimension: sucursal_corta {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_sucursalcorta ;;
    label: "Sucursal (corta)"
  }

  dimension: dsc_codsucursal {
    hidden: no
    type: string
    sql: CONCAT(CAST(${cd_sucursal} AS STRING), ' - ', ${TABLE}.dsc_sucursal) ;;
    label: "Cod - Sucursal"
  }

  dimension: es_capital {
    hidden: no
    type: yesno
    sql: ${TABLE}.flg_escapital = 1 ;;
    label: "Es Capital?"
  }
}
