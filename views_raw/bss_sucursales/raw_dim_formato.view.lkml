# =============================================================================
# RAW view: raw_dim_formato
# Capa CRUDA. Fuente: lakehouse-dev-483619.bss_sucursales.dim_formato
# "Formato Bis": relabel a los nombres del reporte. id_formatopadre agrupa
# Look Isla + Look Store. (La logica CASE del formato de negocio vive aca como
# lectura del origen; la STG solo la expone.)
# =============================================================================

view: raw_dim_formato {
  sql_table_name: `lakehouse-dev-483619.bss_sucursales.dim_formato` ;;
  fields_hidden_by_default: yes

  dimension: id_formato { primary_key: yes type: number sql: ${TABLE}.id_formato ;; }

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
