include: "/views_BAS/bas_bss_sucursales/bas_dim_formato.view.lkml"

view: anl_dim_formato {
  extends: [bas_dim_formato]

  dimension: id_formato { primary_key: yes  hidden: yes }

  dimension: formato_origen {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_formato ;;
    label: "Formato (origen)"
  }

  dimension: formato {
    hidden: no
    type: string
    sql: CASE ${TABLE}.id_formato
           WHEN 3 THEN 'Farmacity'
           WHEN 7 THEN 'Farmacity.com/ML'
           WHEN 6 THEN 'Get The Look'
           WHEN 5 THEN 'Get The Look'
           WHEN 8 THEN 'Simplicity'
           WHEN 9 THEN 'The Food Market'
           ELSE ${TABLE}.dsc_formato
         END ;;
    label: "Formato"
  }
}
