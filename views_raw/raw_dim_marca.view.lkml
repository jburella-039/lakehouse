# =============================================================================
# RAW view: raw_dim_marca
# Capa CRUDA. Fuente: lakehouse-dev-483619.bss_comercial.dim_marca
# La columna del nombre es `dsc_marca` (verificado en INFORMATION_SCHEMA 2026-06-24;
# antes decia "dcs_marca" por error y rompia Top Marcas / filtro Marca).
# =============================================================================

view: raw_dim_marca {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_marca` ;;
  fields_hidden_by_default: yes

  dimension: id_marca      { primary_key: yes type: number sql: ${TABLE}.id_marca ;; }
  dimension: marca         { type: string sql: ${TABLE}.dsc_marca ;;         label: "Marca" }
  dimension: marca_codigo  { type: string sql: ${TABLE}.cd_marca ;; }
  dimension: es_laboratorio { type: yesno sql: ${TABLE}.flg_eslaboratorio ;; label: "Es Laboratorio?" }
}
