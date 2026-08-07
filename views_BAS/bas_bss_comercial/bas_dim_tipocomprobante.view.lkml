view: bas_dim_tipocomprobante {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_tipocomprobante` ;;
  fields_hidden_by_default: yes

  dimension: cd_tipocomprobante {
    type: string
    sql: ${TABLE}.cd_tipocomprobante ;;
  }
  dimension: ds_tkt_tipocomprobante {
    type: string
    sql: ${TABLE}.ds_tkt_tipocomprobante ;;
  }
  dimension: dsc_nombrecampoenvalores {
    type: string
    sql: ${TABLE}.dsc_nombrecampoenvalores ;;
  }
  dimension: flg_activo {
    type: yesno
    sql: ${TABLE}.flg_activo ;;
  }
  dimension: flg_esajuste {
    type: yesno
    sql: ${TABLE}.flg_esajuste ;;
  }
  dimension: flg_escompra {
    type: yesno
    sql: ${TABLE}.flg_escompra ;;
  }
  dimension: flg_esdevolucion {
    type: yesno
    sql: ${TABLE}.flg_esdevolucion ;;
  }
  dimension: flg_esentrada {
    type: yesno
    sql: ${TABLE}.flg_esentrada ;;
  }
  dimension: flg_esmerma {
    type: yesno
    sql: ${TABLE}.flg_esmerma ;;
  }
  dimension: flg_esrecepcion {
    type: yesno
    sql: ${TABLE}.flg_esrecepcion ;;
  }
  dimension: flg_essalida {
    type: yesno
    sql: ${TABLE}.flg_essalida ;;
  }
  dimension: flg_estransferencia {
    type: yesno
    sql: ${TABLE}.flg_estransferencia ;;
  }
  dimension: flg_esventa {
    type: yesno
    sql: ${TABLE}.flg_esventa ;;
  }
  dimension: flg_restastock {
    type: yesno
    sql: ${TABLE}.flg_restastock ;;
  }
  dimension: flg_sumastock {
    type: yesno
    sql: ${TABLE}.flg_sumastock ;;
  }
  dimension: id_grupocomprobante {
    type: number
    sql: ${TABLE}.id_grupocomprobante ;;
  }
  dimension: id_tipocomprobante {
    type: number
    sql: ${TABLE}.id_tipocomprobante ;;
  }
  dimension: mto_maximofacturacion {
    type: number
    sql: ${TABLE}.mto_maximofacturacion ;;
  }
  measure: count {
    type: count
  }
}
