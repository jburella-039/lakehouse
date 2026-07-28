# =============================================================================
# RAW view: raw_dim_categoria
# Capa CRUDA. Fuente: lakehouse-dev-483619.bss_comercial.dim_categoria
# El nombre legible (SIST. DIGESTIVO Y METABOLISMO, ...) esta en dsc_categoria.
# =============================================================================

view: raw_dim_categoria {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_categoria` ;;
  fields_hidden_by_default: yes

  dimension: id_categoria     { primary_key: yes type: number sql: ${TABLE}.id_categoria ;; }
  dimension: categoria        { type: string sql: ${TABLE}.dsc_categoria ;; label: "Categoria" }
  dimension: categoria_codigo { type: string sql: ${TABLE}.cd_categoria ;; }
  dimension: id_departamento  { type: number sql: ${TABLE}.id_departamento ;; }
}
