# =============================================================================
# RAW view: raw_dim_tipocomprobante
# Capa CRUDA. Fuente: lakehouse-dev-483619.bss_comercial.dim_tipocomprobante
# Provee los flags ESVENTA / RESTASTOCK que filtran las medidas base (mapeo v5).
# =============================================================================

view: raw_dim_tipocomprobante {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_tipocomprobante` ;;
  fields_hidden_by_default: yes

  dimension: id_tipocomprobante { primary_key: yes type: number sql: ${TABLE}.id_tipocomprobante ;; }
  dimension: tipo_comprobante   { type: string sql: ${TABLE}.ds_tkt_tipocomprobante ;; label: "Tipo Comprobante" }

  dimension: es_venta      { type: yesno sql: ${TABLE}.flg_esventa ;;      label: "Es Venta?" }
  dimension: resta_stock   { type: yesno sql: ${TABLE}.flg_restastock ;;   label: "Resta Stock?" }
  dimension: es_devolucion { type: yesno sql: ${TABLE}.flg_esdevolucion ;; label: "Es Devolucion?" }
}
