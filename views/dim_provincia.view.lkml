# dim_provincia - trd_sucursales.provincias. Clave: idProvincia.
# Provincia real (Capital Federal, Buenos Aires, Cordoba, ...). Se une por
# dim_sucursal.id_provincia. NOTA: dim_region NO es provincia (son bricks/zonas).
view: dim_provincia {
  sql_table_name: `lakehouse-dev-483619.trd_sucursales.provincias` ;;

  dimension: id_provincia { primary_key: yes type: number sql: ${TABLE}.idProvincia ;; hidden: yes }
  dimension: provincia { type: string sql: ${TABLE}.Provincia ;; label: "Provincia" }
  dimension: sigla { type: string sql: ${TABLE}.Sigla ;; label: "Provincia (sigla)" }
}
