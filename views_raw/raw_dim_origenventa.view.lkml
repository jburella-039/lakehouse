# =============================================================================
# RAW view: raw_dim_origenventa
# Capa CRUDA. Fuente: lakehouse-dev-483619.bss_comercial.dim_origenventa
# Canal de venta (PDV, Farmacity Online, MERCADOFULL, Simplicity Online, Pedidos
# Ya, Rappi, Glovo, WhatsApp, Mercado Libre Flex, ...) y flag de presencialidad.
# =============================================================================

view: raw_dim_origenventa {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_origenventa` ;;
  fields_hidden_by_default: yes

  dimension: id_origenventa { primary_key: yes type: number sql: ${TABLE}.id_origenventa ;; }

  dimension: canal { type: string sql: ${TABLE}.dsc_origenventa ;; label: "Canal" }

  dimension: es_presencial {
    type: yesno
    sql: ${TABLE}.flg_espresencial = 1 ;;
    label: "Es Presencial?"
  }

  # Para el visual Presencial vs No Presencial (Home).
  dimension: presencialidad {
    type: string
    sql: CASE WHEN ${TABLE}.flg_espresencial = 1 THEN 'Presencial' ELSE 'No Presencial' END ;;
    label: "Presencial / No Presencial"
  }
}
