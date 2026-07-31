# dim_provincia - bss_sucursales.dim_provincia. Clave: id_provincia.
# Provincia real (Capital Federal, Buenos Aires, Cordoba, ...). Se une por
# dim_sucursal.id_provincia. NOTA: dim_region NO es provincia (son bricks/zonas).
# Validado 1:1 vs trd_sucursales.provincias (mismos ids y nombres). La fuente nueva
# no trae Sigla, por eso se quita esa dimension (no se usaba en el proyecto).
view: dim_provincia {
  sql_table_name: `lakehouse-dev-483619.bss_sucursales.dim_provincia` ;;

  dimension: id_provincia { primary_key: yes type: number sql: ${TABLE}.id_provincia ;; hidden: yes }
  dimension: provincia { type: string sql: ${TABLE}.dsc_provincia ;; label: "Provincia" }
}
