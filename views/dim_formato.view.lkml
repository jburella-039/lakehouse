# dim_formato - bss_sucursales.dim_formato. Clave: id_formato.
# Fuente corregida por Dani (19/6): usar bss_sucursales (no trd_sucursales).
# "Formato Bis": relabel a los nombres del reporte. Los id_formato coinciden con el
# mapeo anterior (3=Farmacity, 5/6=Get The Look, 7=Farmacity.com/ML, 8=Simplicity,
# 9=The Food Market). id_formatopadre agrupa Look Isla + Look Store.
view: dim_formato {
  sql_table_name: `lakehouse-dev-483619.bss_sucursales.dim_formato` ;;

  dimension: id_formato { primary_key: yes type: number sql: ${TABLE}.id_formato ;; hidden: yes }

  dimension: formato_origen { type: string sql: ${TABLE}.dsc_formato ;; label: "Formato (origen)" }

  # Formato Bis (nombres del reporte). Agrupa Look Isla + Look Store -> Get The Look.
  dimension: formato {
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
