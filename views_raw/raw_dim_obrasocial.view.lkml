# =============================================================================
# RAW view: raw_dim_obrasocial
# Capa CRUDA. Fuente: lakehouse-dev-483619.bss_salud.dim_obrasocial
# =============================================================================

view: raw_dim_obrasocial {
  sql_table_name: `lakehouse-dev-483619.bss_salud.dim_obrasocial` ;;
  fields_hidden_by_default: yes

  dimension: id_obrasocial { primary_key: yes type: number sql: ${TABLE}.idobrasocial ;; }
  dimension: obrasocial    { type: string sql: ${TABLE}.ds_oos_obrasocial ;; label: "Obra Social" }
  dimension: es_coseguro   { type: yesno sql: ${TABLE}.id_oos_escoseguro = 1 ;; label: "Es Coseguro?" }
}
