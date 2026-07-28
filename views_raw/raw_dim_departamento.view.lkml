# =============================================================================
# RAW view: raw_dim_departamento
# Capa CRUDA. Fuente: lakehouse-dev-483619.bss_comercial.dim_departamento
# =============================================================================

view: raw_dim_departamento {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_departamento` ;;
  fields_hidden_by_default: yes

  dimension: id_departamento { primary_key: yes type: number sql: ${TABLE}.id_departamento ;; }
  dimension: departamento    { type: string sql: ${TABLE}.dsc_departamento ;; label: "Departamento" }
}
