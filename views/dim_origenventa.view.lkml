# dim_origenventa - bss_comercial.dim_origenventa. Clave: id_origenventa.
# Canal de venta (PDV, Farmacity Online, MERCADOFULL, Simplicity Online, Pedidos
# Ya, Rappi, Glovo, WhatsApp, Mercado Libre Flex, ...) y flag de presencialidad.
# Confirmado con datos en BigQuery (mar-2026: PDV 96%, Farmacity Online 2.1%, ...).
view: dim_origenventa {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_origenventa` ;;

  dimension: id_origenventa { primary_key: yes hidden: yes type: number sql: ${TABLE}.id_origenventa ;; }

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
