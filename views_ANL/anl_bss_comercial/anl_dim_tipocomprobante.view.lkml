include: "/views_BAS/bas_bss_comercial/bas_dim_tipocomprobante.view.lkml"

view: anl_dim_tipocomprobante {
  extends: [bas_dim_tipocomprobante]

  dimension: id_tipocomprobante { primary_key: yes  hidden: yes }

  dimension: tipo_comprobante {
    hidden: no
    type: string
    sql: ${TABLE}.ds_tkt_tipocomprobante ;;
    label: "Tipo Comprobante"
  }

  dimension: es_venta {
    hidden: no
    type: yesno
    sql: ${TABLE}.flg_esventa ;;
    label: "Es Venta?"
  }
  dimension: resta_stock {
    hidden: no
    type: yesno
    sql: ${TABLE}.flg_restastock ;;
    label: "Resta Stock?"
  }
  dimension: es_devolucion {
    hidden: no
    type: yesno
    sql: ${TABLE}.flg_esdevolucion ;;
    label: "Es Devolucion?"
  }
}
