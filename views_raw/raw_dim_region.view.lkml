# =============================================================================
# RAW view: raw_dim_region
# Capa CRUDA. Fuente: lakehouse-dev-483619.bss_sucursales.dim_region
# Validado 1:1 vs trd_sucursales.regiones (mismos ids y nombres).
# =============================================================================

view: raw_dim_region {
  sql_table_name: `lakehouse-dev-483619.bss_sucursales.dim_region` ;;
  fields_hidden_by_default: yes

  dimension: id_region { primary_key: yes type: number sql: ${TABLE}.id_region ;; }
  dimension: region    { type: string sql: ${TABLE}.dsc_region ;; label: "Region" }
}
