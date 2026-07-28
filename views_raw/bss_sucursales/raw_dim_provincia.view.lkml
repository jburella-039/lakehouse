# =============================================================================
# RAW view: raw_dim_provincia
# Capa CRUDA. Fuente: lakehouse-dev-483619.bss_sucursales.dim_provincia
# Provincia real (Capital Federal, Buenos Aires, Cordoba, ...). Se une por
# dim_sucursal.id_provincia. NOTA: dim_region NO es provincia (son bricks/zonas).
# =============================================================================

view: raw_dim_provincia {
  sql_table_name: `lakehouse-dev-483619.bss_sucursales.dim_provincia` ;;
  fields_hidden_by_default: yes

  dimension: id_provincia { primary_key: yes type: number sql: ${TABLE}.id_provincia ;; }
  dimension: provincia    { type: string sql: ${TABLE}.dsc_provincia ;; label: "Provincia" }
}
