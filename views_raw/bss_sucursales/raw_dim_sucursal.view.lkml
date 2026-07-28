# =============================================================================
# RAW view: raw_dim_sucursal
# Capa CRUDA. Fuente: lakehouse-dev-483619.bss_sucursales.dim_sucursal
# =============================================================================

view: raw_dim_sucursal {
  sql_table_name: `lakehouse-dev-483619.bss_sucursales.dim_sucursal` ;;
  fields_hidden_by_default: yes

  dimension: id_sucursal    { primary_key: yes type: number sql: ${TABLE}.id_sucursal ;; label: "Sucursal (ID)" }
  dimension: cd_sucursal    { type: number sql: ${TABLE}.cd_sucursal ;;        label: "Sucursal (codigo)" }
  dimension: sucursal       { type: string sql: ${TABLE}.dsc_sucursal ;;       label: "Sucursal" }
  dimension: sucursal_corta { type: string sql: ${TABLE}.dsc_sucursalcorta ;;  label: "Sucursal (corta)" }

  # "<cd_sucursal> - <descripcion>". Para el filtro Sucursal del tablero.
  dimension: dsc_codsucursal {
    type: string
    sql: CONCAT(CAST(${cd_sucursal} AS STRING), ' - ', ${TABLE}.dsc_sucursal) ;;
    label: "Cod - Sucursal"
  }

  dimension: id_formato   { type: number sql: ${TABLE}.id_formato ;; }
  dimension: id_region    { type: number sql: ${TABLE}.id_region ;; }
  dimension: id_provincia { type: number sql: ${TABLE}.id_provincia ;; }
  dimension: es_capital   { type: yesno sql: ${TABLE}.flg_escapital = 1 ;; label: "Es Capital?" }
}
