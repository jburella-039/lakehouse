view: bas_fct_ventas {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.vw_fct_ventas` ;;

  dimension: cd_cliente {
    hidden: yes
    type: number
    sql: ${TABLE}.cd_cliente ;;
  }
  dimension: cd_documento {
    hidden: yes
    type: number
    sql: ${TABLE}.cd_documento ;;
  }
  dimension: cd_documentofiscal {
    hidden: yes
    type: string
    sql: ${TABLE}.cd_documentofiscal ;;
  }
  dimension: cd_nrocomprobante {
    type: number
    sql: ${TABLE}.cd_nrocomprobante ;;
  }
  dimension: cd_nrocomprobantefiscal {
    hidden: yes
    type: number
    sql: ${TABLE}.cd_nrocomprobantefiscal ;;
  }
  dimension: cd_nrocomprobanterelacionado {
    hidden: yes
    type: number
    sql: ${TABLE}.cd_nrocomprobanterelacionado ;;
  }
  dimension: cd_nroremito {
    hidden: yes
    type: number
    sql: ${TABLE}.cd_nroremito ;;
  }
  dimension: cd_padrecoseguro {
    hidden: yes
    type: number
    sql: ${TABLE}.cd_padrecoseguro ;;
  }
  dimension: cd_padreobrasocial {
    hidden: yes
    type: number
    sql: ${TABLE}.cd_padreobrasocial ;;
  }
  dimension: cd_sku {
    type: number
    sql: ${TABLE}.cd_sku ;;
  }
  dimension: cd_tipodocumentofiscal {
    hidden: yes
    type: number
    sql: ${TABLE}.cd_tipodocumentofiscal ;;
  }
  dimension: cnt_bonificacion {
    hidden: yes
    type: number
    sql: ${TABLE}.cnt_bonificacion ;;
  }
  dimension: cnt_cupondescuento {
    hidden: yes
    type: number
    sql: ${TABLE}.cnt_cupondescuento ;;
  }
  dimension: cnt_farmacia {
    hidden: yes
    type: number
    sql: ${TABLE}.cnt_farmacia ;;
  }
  dimension: cnt_promociondescuento {
    hidden: yes
    type: number
    sql: ${TABLE}.cnt_promociondescuento ;;
  }
  dimension: cnt_unidades {
    hidden: yes
    type: number
    sql: ${TABLE}.cnt_unidades ;;
  }
  dimension: dsc_domicilioentrega {
    hidden: yes
    type: string
    sql: ${TABLE}.dsc_domicilioentrega ;;
  }
  dimension: eml_comprobantefiscal {
    hidden: yes
    type: string
    sql: ${TABLE}.eml_comprobantefiscal ;;
  }
  dimension: fec_aniomes {
    hidden: yes
    type: number
    sql: ${TABLE}.fec_aniomes ;;
  }
  dimension: fec_carga {
    hidden: yes
    type: number
    sql: ${TABLE}.fec_carga ;;
  }
  dimension_group: fec_dia {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_dia ;;
  }
  dimension: fec_diarelacionado {
    hidden: yes
    type: number
    sql: ${TABLE}.fec_diarelacionado ;;
  }
  dimension_group: fec_emisionfiscal {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_emisionfiscal ;;
  }
  dimension_group: fec_escaneo {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_escaneo ;;
  }
  dimension_group: fec_pedido {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_pedido ;;
  }
  dimension_group: fec_venta {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_venta ;;
  }
  dimension: flg_clientecalculado {
    hidden: yes
    type: number
    sql: ${TABLE}.flg_clientecalculado ;;
  }
  dimension: flg_serviciosalud {
    hidden: yes
    type: number
    sql: ${TABLE}.flg_serviciosalud ;;
  }
  dimension: id_caja {
    type: number
    sql: ${TABLE}.id_caja ;;
  }
  dimension: id_cajarelacionado {
    hidden: yes
    type: number
    sql: ${TABLE}.id_cajarelacionado ;;
  }
  dimension: id_categoria {
    type: number
    sql: ${TABLE}.id_categoria ;;
  }
  dimension: id_cliente {
    type: number
    sql: ${TABLE}.id_cliente ;;
  }
  dimension: id_coseguro {
    hidden: yes
    type: number
    sql: ${TABLE}.id_coseguro ;;
  }
  dimension: id_cupondescuento {
    hidden: yes
    type: number
    sql: ${TABLE}.id_cupondescuento ;;
  }
  dimension: id_departamento {
    type: number
    sql: ${TABLE}.id_departamento ;;
  }
  dimension: id_empleadodescuento {
    hidden: yes
    type: number
    sql: ${TABLE}.id_empleadodescuento ;;
  }
  dimension: id_legajoautorizador {
    hidden: yes
    type: number
    sql: ${TABLE}.id_legajoautorizador ;;
  }
  dimension: id_legajocajero {
    hidden: yes
    type: number
    sql: ${TABLE}.id_legajocajero ;;
  }
  dimension: id_legajocolaborador {
    hidden: yes
    type: number
    sql: ${TABLE}.id_legajocolaborador ;;
  }
  dimension: id_marca {
    type: number
    sql: ${TABLE}.id_marca ;;
  }
  dimension: id_motivonc {
    hidden: yes
    type: number
    sql: ${TABLE}.id_motivonc ;;
  }
  dimension: id_nroapertura {
    hidden: yes
    type: number
    sql: ${TABLE}.id_nroapertura ;;
  }
  dimension: id_nroaperturarelacionado {
    hidden: yes
    type: number
    sql: ${TABLE}.id_nroaperturarelacionado ;;
  }
  dimension: id_nroorden {
    hidden: yes
    type: string
    sql: ${TABLE}.id_nroorden ;;
  }
  dimension: id_nropedido {
    hidden: yes
    type: number
    sql: ${TABLE}.id_nropedido ;;
  }
  dimension: id_obrasocial {
    type: number
    sql: ${TABLE}.id_obrasocial ;;
  }
  dimension: id_origenventa {
    hidden: yes
    type: number
    sql: ${TABLE}.id_origenventa ;;
  }
  dimension: id_pdvfiscal {
    hidden: yes
    type: number
    sql: ${TABLE}.id_pdvfiscal ;;
  }
  dimension: id_programacomercial {
    hidden: yes
    type: number
    sql: ${TABLE}.id_programacomercial ;;
  }
  dimension: id_proveedor {
    type: number
    sql: ${TABLE}.id_proveedor ;;
  }
  dimension: id_subcategoria {
    type: number
    sql: ${TABLE}.id_subcategoria ;;
  }
  dimension: id_sucursal {
    type: number
    sql: ${TABLE}.id_sucursal ;;
  }
  dimension: id_sucursalpet {
    hidden: yes
    type: number
    sql: ${TABLE}.id_sucursalpet ;;
  }
  dimension: id_tipocomprobante {
    type: number
    sql: ${TABLE}.id_tipocomprobante ;;
  }
  dimension: id_tipocomprobanterelacionado {
    hidden: yes
    type: number
    sql: ${TABLE}.id_tipocomprobanterelacionado ;;
  }
  dimension: id_tipoiva {
    hidden: yes
    type: number
    sql: ${TABLE}.id_tipoiva ;;
  }
  dimension: id_tipooperacioncomercial {
    hidden: yes
    type: number
    sql: ${TABLE}.id_tipooperacioncomercial ;;
  }
  dimension: id_ventaunica {
    hidden: yes
    type: number
    sql: ${TABLE}.id_ventaunica ;;
  }
  dimension: mto_bonificacion {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_bonificacion ;;
  }
  dimension: mto_cantidadgranel {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_cantidadgranel ;;
  }
  dimension: mto_coseguro {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_coseguro ;;
  }
  dimension: mto_costo {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_costo ;;
  }
  dimension: mto_cupondescuento {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_cupondescuento ;;
  }
  dimension: mto_cupondescuentosiniva {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_cupondescuentosiniva ;;
  }
  dimension: mto_farmacia {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_farmacia ;;
  }
  dimension: mto_iva {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_iva ;;
  }
  dimension: mto_montofarmaciatickitems {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_montofarmaciatickitems ;;
  }
  dimension: mto_obrasocial {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_obrasocial ;;
  }
  dimension: mto_percepcioniva {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_percepcioniva ;;
  }
  dimension: mto_preciostotalsiniva {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_preciostotalsiniva ;;
  }
  dimension: mto_preciounitariopublico {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_preciounitariopublico ;;
  }
  dimension: mto_promociondescuento {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_promociondescuento ;;
  }
  dimension: mto_rentabilidadsku {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_rentabilidadsku ;;
  }
  dimension: mto_total {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_total ;;
  }
  dimension: mto_totalempleadodescuento {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_totalempleadodescuento ;;
  }
  dimension: mto_totalempleadodescuentociva {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_totalempleadodescuentociva ;;
  }
  dimension: mto_totalsinivaantesdescuento {
    hidden: yes
    type: number
    sql: ${TABLE}.mto_totalsinivaantesdescuento ;;
  }
  dimension: num_hora {
    type: number
    sql: ${TABLE}.num_hora ;;
  }
  dimension: pct_cupondescuento {
    hidden: yes
    type: number
    sql: ${TABLE}.pct_cupondescuento ;;
  }
  dimension: pct_iva {
    hidden: yes
    type: number
    sql: ${TABLE}.pct_iva ;;
  }
  dimension: pct_percepcioniva {
    hidden: yes
    type: number
    sql: ${TABLE}.pct_percepcioniva ;;
  }
  dimension: pct_promociondescuento {
    hidden: yes
    type: number
    sql: ${TABLE}.pct_promociondescuento ;;
  }
  dimension: pct_recargofinanciero {
    hidden: yes
    type: number
    sql: ${TABLE}.pct_recargofinanciero ;;
  }
  measure: count {
    hidden: yes
    type: count
  }
}
