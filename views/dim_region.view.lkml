# dim_region — trd_sucursales.regiones. Clave: Region.
view: dim_region {
  sql_table_name: `lakehouse-dev-483619.trd_sucursales.regiones` ;;

  dimension: id_region { primary_key: yes type: number sql: ${TABLE}.Region ;; hidden: yes }
  dimension: region { type: string sql: ${TABLE}.Nombre ;; label: "Región" }
}
