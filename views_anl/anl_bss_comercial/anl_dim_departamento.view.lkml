include: "/views_bas/bas_bss_comercial/bas_dim_departamento.view.lkml"

view: anl_dim_departamento {
  extends: [bas_dim_departamento]

  dimension: id_departamento { primary_key: yes  hidden: yes }

  dimension: departamento {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_departamento ;;
    label: "Departamento"
  }
}
