# =============================================================================
# RAW view: raw_dim_subcategoria
# Capa CRUDA. Fuente: lakehouse-dev-483619.bss_comercial.dim_subcategoria
# Nombre en dsc_subcategoria.
# =============================================================================

view: raw_dim_subcategoria {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_subcategoria` ;;
  fields_hidden_by_default: yes

  dimension: id_subcategoria { primary_key: yes type: number sql: ${TABLE}.id_subcategoria ;; }
  dimension: subcategoria    { type: string sql: ${TABLE}.dsc_subcategoria ;; label: "Subcategoria" }
  dimension: id_categoria    { type: number sql: ${TABLE}.id_categoria ;; }
}
