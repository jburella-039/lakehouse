view: bas_fct_remitos {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.vw_fct_remitos` ;;
  fields_hidden_by_default: yes

  dimension: cd_autorizacion {
    type: string
    sql: ${TABLE}.cd_autorizacion ;;
  }
  dimension: cd_autorizacioncoseguro {
    type: string
    sql: ${TABLE}.cd_autorizacioncoseguro ;;
  }
  dimension: cd_cancelacion {
    type: string
    sql: ${TABLE}.cd_cancelacion ;;
  }
  dimension: cd_cancelacioncoseguro {
    type: string
    sql: ${TABLE}.cd_cancelacioncoseguro ;;
  }
  dimension: cd_nrocomprobante {
    type: number
    sql: ${TABLE}.cd_nrocomprobante ;;
  }
  dimension: cd_nroreceta {
    type: number
    sql: ${TABLE}.cd_nroreceta ;;
  }
  dimension: cd_sku {
    type: number
    sql: ${TABLE}.cd_sku ;;
  }
  dimension: cd_tipoprescripcion {
    type: string
    sql: ${TABLE}.cd_tipoprescripcion ;;
  }
  dimension: cnt_unidades {
    type: number
    sql: ${TABLE}.cnt_unidades ;;
  }
  dimension: dsc_autorizacion {
    type: string
    sql: ${TABLE}.dsc_autorizacion ;;
  }
  dimension: dsc_dispensa {
    type: string
    sql: ${TABLE}.dsc_dispensa ;;
  }
  dimension: dsc_nombreafiliadocoseguro {
    type: string
    sql: ${TABLE}.dsc_nombreafiliadocoseguro ;;
  }
  dimension: dsc_nombreafiliadoobrasocial {
    type: string
    sql: ${TABLE}.dsc_nombreafiliadoobrasocial ;;
  }
  dimension: dsc_nombremedico {
    type: string
    sql: ${TABLE}.dsc_nombremedico ;;
  }
  dimension: dsc_nroafiliadocoseguro {
    type: string
    sql: ${TABLE}.dsc_nroafiliadocoseguro ;;
  }
  dimension: dsc_nroafiliadoobrasocial {
    type: string
    sql: ${TABLE}.dsc_nroafiliadoobrasocial ;;
  }
  dimension: fec_aniomes {
    type: number
    sql: ${TABLE}.fec_aniomes ;;
  }
  dimension_group: fec_dia {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_dia ;;
  }
  dimension: fec_hora {
    type: number
    sql: ${TABLE}.fec_hora ;;
  }
  dimension_group: fec_horacompleta {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_horacompleta ;;
  }
  dimension_group: fec_horaemision {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_horaemision ;;
  }
  dimension_group: fec_horaingreso {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_horaingreso ;;
  }
  dimension: flg_clientecalculado {
    type: number
    sql: ${TABLE}.flg_clientecalculado ;;
  }
  dimension: flg_esrecetadigital {
    type: number
    sql: ${TABLE}.flg_esrecetadigital ;;
  }
  dimension: flg_presentaciondigital {
    type: number
    sql: ${TABLE}.flg_presentaciondigital ;;
  }
  dimension: flg_psicotropico {
    type: number
    sql: ${TABLE}.flg_psicotropico ;;
  }
  dimension: flg_skugenerico {
    type: number
    sql: ${TABLE}.flg_skugenerico ;;
  }
  dimension: id_caja {
    type: number
    sql: ${TABLE}.id_caja ;;
  }
  dimension: id_categoria {
    type: number
    sql: ${TABLE}.id_categoria ;;
  }
  dimension: id_cliente {
    type: number
    sql: ${TABLE}.id_cliente ;;
  }
  dimension: id_comercial {
    type: number
    sql: ${TABLE}.id_comercial ;;
  }
  dimension: id_coseguro {
    type: number
    sql: ${TABLE}.id_coseguro ;;
  }
  dimension: id_departamento {
    type: number
    sql: ${TABLE}.id_departamento ;;
  }
  dimension: id_estadoremito {
    type: number
    sql: ${TABLE}.id_estadoremito ;;
  }
  dimension: id_etlcargadatos {
    type: number
    sql: ${TABLE}.id_etlcargadatos ;;
  }
  dimension: id_legajoempleadofarmacia {
    type: number
    sql: ${TABLE}.id_legajoempleadofarmacia ;;
  }
  dimension: id_marca {
    type: number
    sql: ${TABLE}.id_marca ;;
  }
  dimension: id_nroapertura {
    type: number
    sql: ${TABLE}.id_nroapertura ;;
  }
  dimension: id_nromatricula {
    type: number
    sql: ${TABLE}.id_nromatricula ;;
  }
  dimension: id_nropreparado {
    type: number
    sql: ${TABLE}.id_nropreparado ;;
  }
  dimension: id_nroremito {
    type: number
    sql: ${TABLE}.id_nroremito ;;
  }
  dimension: id_nrovaleasociado {
    type: number
    sql: ${TABLE}.id_nrovaleasociado ;;
  }
  dimension: id_obrasocial {
    type: number
    sql: ${TABLE}.id_obrasocial ;;
  }
  dimension: id_origenventa {
    type: number
    sql: ${TABLE}.id_origenventa ;;
  }
  dimension: id_proveedor {
    type: number
    sql: ${TABLE}.id_proveedor ;;
  }
  dimension: id_puntoventafarmacia {
    type: number
    sql: ${TABLE}.id_puntoventafarmacia ;;
  }
  dimension: id_responsableautorizacion {
    type: number
    sql: ${TABLE}.id_responsableautorizacion ;;
  }
  dimension: id_subcategoria {
    type: number
    sql: ${TABLE}.id_subcategoria ;;
  }
  dimension: id_sucursal {
    type: number
    sql: ${TABLE}.id_sucursal ;;
  }
  dimension: id_tipocomprobante {
    type: number
    sql: ${TABLE}.id_tipocomprobante ;;
  }
  dimension: id_tipodispensa {
    type: number
    sql: ${TABLE}.id_tipodispensa ;;
  }
  dimension: id_tipoiva {
    type: number
    sql: ${TABLE}.id_tipoiva ;;
  }
  dimension: id_tipooperacioncomercial {
    type: number
    sql: ${TABLE}.id_tipooperacioncomercial ;;
  }
  dimension: id_tipoplancoseguro {
    type: number
    sql: ${TABLE}.id_tipoplancoseguro ;;
  }
  dimension: id_tipoplanobrasocial {
    type: number
    sql: ${TABLE}.id_tipoplanobrasocial ;;
  }
  dimension: id_tiporemito {
    type: number
    sql: ${TABLE}.id_tiporemito ;;
  }
  dimension: id_venta {
    type: number
    sql: ${TABLE}.id_venta ;;
  }
  dimension: mto_acobrar {
    type: number
    sql: ${TABLE}.mto_acobrar ;;
  }
  dimension: mto_coseguro {
    type: number
    sql: ${TABLE}.mto_coseguro ;;
  }
  dimension: mto_costofarmacia {
    type: number
    sql: ${TABLE}.mto_costofarmacia ;;
  }
  dimension: mto_costototal {
    type: number
    sql: ${TABLE}.mto_costototal ;;
  }
  dimension: mto_cupondescuento {
    type: number
    sql: ${TABLE}.mto_cupondescuento ;;
  }
  dimension: mto_descuentoefectivo {
    type: number
    sql: ${TABLE}.mto_descuentoefectivo ;;
  }
  dimension: mto_descuentoempleado {
    type: number
    sql: ${TABLE}.mto_descuentoempleado ;;
  }
  dimension: mto_descuentofarmacia {
    type: number
    sql: ${TABLE}.mto_descuentofarmacia ;;
  }
  dimension: mto_descuentofp {
    type: number
    sql: ${TABLE}.mto_descuentofp ;;
  }
  dimension: mto_obrasocial {
    type: number
    sql: ${TABLE}.mto_obrasocial ;;
  }
  dimension: mto_total {
    type: number
    sql: ${TABLE}.mto_total ;;
  }
  dimension: mto_totaldescuentoempleado {
    type: number
    sql: ${TABLE}.mto_totaldescuentoempleado ;;
  }
  dimension: mto_totalsiniva {
    type: number
    sql: ${TABLE}.mto_totalsiniva ;;
  }
  measure: count {
    type: count
  }
}
