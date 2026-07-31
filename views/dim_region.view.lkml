# dim_region - bss_sucursales.dim_region. Clave: id_region.
# Validado 1:1 vs trd_sucursales.regiones (mismos ids y nombres).
view: dim_region {
  sql_table_name: `lakehouse-dev-483619.bss_sucursales.dim_region` ;;

  dimension: id_region { primary_key: yes type: number sql: ${TABLE}.id_region ;; hidden: yes }
  dimension: region { type: string sql: ${TABLE}.dsc_region ;; label: "Region" }
}
