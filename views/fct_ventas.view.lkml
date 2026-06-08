view: fct_ventas {
  sql_table_name: `bss_oracle.fct_ventas` ;;

  dimension: cd_cliente {
    type: number
    sql: ${TABLE}.cd_cliente ;;
  }
  dimension: cd_documento {
    type: number
    sql: ${TABLE}.cd_documento ;;
  }
  dimension: cd_documentofiscal {
    type: string
    sql: ${TABLE}.cd_documentofiscal ;;
  }
  dimension: cd_nrocomprobante {
    type: number
    sql: ${TABLE}.cd_nrocomprobante ;;
  }
  dimension: cd_nrocomprobantefiscal {
    type: number
    sql: ${TABLE}.cd_nrocomprobantefiscal ;;
  }
  dimension: cd_nrocomprobanterelacionado {
    type: number
    sql: ${TABLE}.cd_nrocomprobanterelacionado ;;
  }
  dimension: cd_sku {
    type: number
    sql: ${TABLE}.cd_sku ;;
  }
  dimension: cd_tipodocumentofiscal {
    type: number
    sql: ${TABLE}.cd_tipodocumentofiscal ;;
  }
  dimension: cnt_bonificacion {
    type: number
    sql: ${TABLE}.cnt_bonificacion ;;
  }
  dimension: cnt_cantidad {
    type: number
    sql: ${TABLE}.cnt_cantidad ;;
  }
  dimension: cnt_cupondescuento {
    type: number
    sql: ${TABLE}.cnt_cupondescuento ;;
  }
  dimension: cnt_farmacia {
    type: number
    sql: ${TABLE}.cnt_farmacia ;;
  }
  dimension: cnt_promodescuento {
    type: number
    sql: ${TABLE}.cnt_promodescuento ;;
  }
  dimension: dsc_domicilioentrega {
    type: string
    sql: ${TABLE}.dsc_domicilioentrega ;;
  }
  dimension: eml_comprobantefiscal {
    type: string
    sql: ${TABLE}.eml_comprobantefiscal ;;
  }
  dimension: fec_carga {
    type: number
    sql: ${TABLE}.fec_carga ;;
  }
  dimension_group: fec_dia {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_dia ;;
  }
  dimension: fec_diarelacionado {
    type: number
    sql: ${TABLE}.fec_diarelacionado ;;
  }
  dimension_group: fec_emisionfiscal {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_emisionfiscal ;;
  }
  dimension_group: fec_escaneo {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_escaneo ;;
  }
  dimension: fec_mesnum {
    type: number
    sql: ${TABLE}.fec_mesnum ;;
  }
  dimension_group: fec_pedido {
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
    type: number
    sql: ${TABLE}.flg_clientecalculado ;;
  }
  dimension: flg_serviciosalud {
    type: number
    sql: ${TABLE}.flg_serviciosalud ;;
  }
  dimension: id_caja {
    type: number
    sql: ${TABLE}.id_caja ;;
  }
  dimension: id_cajarelacionado {
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
    type: number
    sql: ${TABLE}.id_coseguro ;;
  }
  dimension: id_cupondescuento {
    type: number
    sql: ${TABLE}.id_cupondescuento ;;
  }
  dimension: id_departamento {
    type: number
    sql: ${TABLE}.id_departamento ;;
  }
  dimension: id_empleadodescuento {
    type: number
    sql: ${TABLE}.id_empleadodescuento ;;
  }
  dimension: id_legajoautorizador {
    type: number
    sql: ${TABLE}.id_legajoautorizador ;;
  }
  dimension: id_legajocajero {
    type: number
    sql: ${TABLE}.id_legajocajero ;;
  }
  dimension: id_legajocolaborador {
    type: number
    sql: ${TABLE}.id_legajocolaborador ;;
  }
  dimension: id_marca {
    type: number
    sql: ${TABLE}.id_marca ;;
  }
  dimension: id_motivonc {
    type: number
    sql: ${TABLE}.id_motivonc ;;
  }
  dimension: id_nroapertura {
    type: number
    sql: ${TABLE}.id_nroapertura ;;
  }
  dimension: id_nroaperturarelacionado {
    type: number
    sql: ${TABLE}.id_nroaperturarelacionado ;;
  }
  dimension: id_nroorden {
    type: string
    sql: ${TABLE}.id_nroorden ;;
  }
  dimension: id_nropedido {
    type: number
    sql: ${TABLE}.id_nropedido ;;
  }
  dimension: id_nroremito {
    type: number
    sql: ${TABLE}.id_nroremito ;;
  }
  dimension: id_obrasocial {
    type: number
    sql: ${TABLE}.id_obrasocial ;;
  }
  dimension: id_origenventa {
    type: number
    sql: ${TABLE}.id_origenventa ;;
  }
  dimension: id_padrecoseguro {
    type: number
    sql: ${TABLE}.id_padrecoseguro ;;
  }
  dimension: id_padreobrasocial {
    type: number
    sql: ${TABLE}.id_padreobrasocial ;;
  }
  dimension: id_pdvfiscal {
    type: number
    sql: ${TABLE}.id_pdvfiscal ;;
  }
  dimension: id_programacomercial {
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
    type: number
    sql: ${TABLE}.id_sucursalpet ;;
  }
  dimension: id_tipocomprobante {
    type: number
    sql: ${TABLE}.id_tipocomprobante ;;
  }
  dimension: id_tipocomprobanterelacionado {
    type: number
    sql: ${TABLE}.id_tipocomprobanterelacionado ;;
  }
  dimension: id_tipoiva {
    type: number
    sql: ${TABLE}.id_tipoiva ;;
  }
  dimension: id_tipooperacioncomercial {
    type: number
    sql: ${TABLE}.id_tipooperacioncomercial ;;
  }
  dimension: id_ventaunica {
    type: number
    sql: ${TABLE}.id_ventaunica ;;
  }
  dimension: mto_bonificacion {
    type: number
    sql: ${TABLE}.mto_bonificacion ;;
  }
  dimension: mto_cantidadgranel {
    type: number
    sql: ${TABLE}.mto_cantidadgranel ;;
  }
  dimension: mto_coseguro {
    type: number
    sql: ${TABLE}.mto_coseguro ;;
  }
  dimension: mto_costo {
    type: number
    sql: ${TABLE}.mto_costo ;;
  }
  dimension: mto_cupondescuento {
    type: number
    sql: ${TABLE}.mto_cupondescuento ;;
  }
  dimension: mto_cupondescuentosiniva {
    type: number
    sql: ${TABLE}.mto_cupondescuentosiniva ;;
  }
  dimension: mto_farmacia {
    type: number
    sql: ${TABLE}.mto_farmacia ;;
  }
  dimension: mto_iva {
    type: number
    sql: ${TABLE}.mto_iva ;;
  }
  dimension: mto_montofarmaciatickitems {
    type: number
    sql: ${TABLE}.mto_montofarmaciatickitems ;;
  }
  dimension: mto_obrasocial {
    type: number
    sql: ${TABLE}.mto_obrasocial ;;
  }
  dimension: mto_percepcioniva {
    type: number
    sql: ${TABLE}.mto_percepcioniva ;;
  }
  dimension: mto_preciostotalsiniva {
    type: number
    sql: ${TABLE}.mto_preciostotalsiniva ;;
  }
  dimension: mto_preciounitariopublico {
    type: number
    sql: ${TABLE}.mto_preciounitariopublico ;;
  }
  dimension: mto_promodescuento {
    type: number
    sql: ${TABLE}.mto_promodescuento ;;
  }
  dimension: mto_rentabilidadporsku {
    type: number
    sql: ${TABLE}.mto_rentabilidadporsku ;;
  }
  dimension: mto_total {
    type: number
    sql: ${TABLE}.mto_total ;;
  }
  dimension: mto_totalempleadodescuento {
    type: number
    sql: ${TABLE}.mto_totalempleadodescuento ;;
  }
  dimension: mto_totalempleadodescuentociva {
    type: number
    sql: ${TABLE}.mto_totalempleadodescuentociva ;;
  }
  dimension: mto_totalsinivaantesdescuento {
    type: number
    sql: ${TABLE}.mto_totalsinivaantesdescuento ;;
  }
  dimension: num_hora {
    type: number
    sql: ${TABLE}.num_hora ;;
  }
  dimension: pct_cupondescuento {
    type: number
    sql: ${TABLE}.pct_cupondescuento ;;
  }
  dimension: pct_iva {
    type: number
    sql: ${TABLE}.pct_iva ;;
  }
  dimension: pct_percepcioniva {
    type: number
    sql: ${TABLE}.pct_percepcioniva ;;
  }
  dimension: pct_promodescuento {
    type: number
    sql: ${TABLE}.pct_promodescuento ;;
  }
  dimension: pct_recargofinanciero {
    type: number
    sql: ${TABLE}.pct_recargofinanciero ;;
  }
  measure: count {
    type: count
  }
}
