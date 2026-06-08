# dim_formato — trd_sucursales.sucursalesformato. Clave: CodFormato.
# "Formato Bis": relabel/agrupación de presentación del Power BI.
view: dim_formato {
  sql_table_name: `lakehouse-dev-483619.trd_sucursales.sucursalesformato` ;;

  dimension: cod_formato { primary_key: yes type: number sql: ${TABLE}.CodFormato ;; hidden: yes }

  dimension: formato_origen { type: string sql: ${TABLE}.Descripcion ;; label: "Formato (origen)" }

  # Formato Bis (nombres del reporte). Agrupa Look Isla + Look Store -> Get The Look.
  dimension: formato {
    type: string
    sql: CASE ${TABLE}.CodFormato
           WHEN 3 THEN 'Farmacity'
           WHEN 7 THEN 'Farmacity.com/ML'
           WHEN 6 THEN 'Get The Look'
           WHEN 5 THEN 'Get The Look'
           WHEN 8 THEN 'Simplicity'
           WHEN 9 THEN 'The Food Market'
           ELSE ${TABLE}.Descripcion
         END ;;
    label: "Formato"
  }
}
