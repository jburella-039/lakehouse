view: bas_dim_articulo {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_articulo` ;;
  fields_hidden_by_default: yes

  dimension: cd_sku {
    type: number
    sql: ${TABLE}.cd_sku ;;
  }
  dimension: cnt_alto {
    type: number
    sql: ${TABLE}.cnt_alto ;;
  }
  dimension: cnt_ancho {
    type: number
    sql: ${TABLE}.cnt_ancho ;;
  }
  dimension: cnt_pisospallet {
    type: number
    sql: ${TABLE}.cnt_pisospallet ;;
  }
  dimension: cnt_profundo {
    type: number
    sql: ${TABLE}.cnt_profundo ;;
  }
  dimension: cnt_ubf {
    type: number
    sql: ${TABLE}.cnt_ubf ;;
  }
  dimension: cnt_ubp {
    type: number
    sql: ${TABLE}.cnt_ubp ;;
  }
  dimension: cnt_upp {
    type: number
    sql: ${TABLE}.cnt_upp ;;
  }
  dimension: dsc_codbarra {
    type: string
    sql: ${TABLE}.dsc_codbarra ;;
  }
  dimension: dsc_sku {
    type: string
    sql: ${TABLE}.dsc_sku ;;
  }
  dimension_group: fec_alta {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_alta ;;
  }
  dimension_group: fec_modificacion {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_modificacion ;;
  }
  dimension: flg_esecommerce {
    type: string
    sql: ${TABLE}.flg_esecommerce ;;
  }
  dimension: flg_esfraccionado {
    type: string
    sql: ${TABLE}.flg_esfraccionado ;;
  }
  dimension: flg_eshijo {
    type: number
    sql: ${TABLE}.flg_eshijo ;;
  }
  dimension: flg_espadre {
    type: number
    sql: ${TABLE}.flg_espadre ;;
  }
  dimension: flg_requieretrazabilidad {
    type: number
    sql: ${TABLE}.flg_requieretrazabilidad ;;
  }
  dimension: flg_skuservicio {
    type: number
    sql: ${TABLE}.flg_skuservicio ;;
  }
  dimension: flg_tienevencimiento {
    type: yesno
    sql: ${TABLE}.flg_tienevencimiento ;;
  }
  dimension: flg_ventagranel {
    type: number
    sql: ${TABLE}.flg_ventagranel ;;
  }
  dimension: id_afectastk {
    type: number
    sql: ${TABLE}.id_afectastk ;;
  }
  dimension: id_articuloestado {
    type: number
    sql: ${TABLE}.id_articuloestado ;;
  }
  dimension: id_articulosubestado {
    type: number
    sql: ${TABLE}.id_articulosubestado ;;
  }
  dimension: id_articulotipo {
    type: number
    sql: ${TABLE}.id_articulotipo ;;
  }
  dimension: id_categoria {
    type: number
    sql: ${TABLE}.id_categoria ;;
  }
  dimension: id_departamento {
    type: number
    sql: ${TABLE}.id_departamento ;;
  }
  dimension: id_grupo {
    type: number
    sql: ${TABLE}.id_grupo ;;
  }
  dimension: id_marca {
    type: number
    sql: ${TABLE}.id_marca ;;
  }
  dimension: id_marcapropia {
    type: number
    sql: ${TABLE}.id_marcapropia ;;
  }
  dimension: id_paisorigen {
    type: number
    sql: ${TABLE}.id_paisorigen ;;
  }
  dimension: id_proveedor {
    type: number
    sql: ${TABLE}.id_proveedor ;;
  }
  dimension: id_sector {
    type: number
    sql: ${TABLE}.id_sector ;;
  }
  dimension: id_subcategoria {
    type: number
    sql: ${TABLE}.id_subcategoria ;;
  }
  dimension: id_temporada {
    type: number
    sql: ${TABLE}.id_temporada ;;
  }
  dimension: id_tipoiva {
    type: number
    sql: ${TABLE}.id_tipoiva ;;
  }
  dimension: id_tipomedida {
    type: number
    sql: ${TABLE}.id_tipomedida ;;
  }
  dimension: id_tipoprecio {
    type: number
    sql: ${TABLE}.id_tipoprecio ;;
  }
  dimension: id_tiporotacion {
    type: number
    sql: ${TABLE}.id_tiporotacion ;;
  }
  dimension: mto_costocalculado {
    type: number
    sql: ${TABLE}.mto_costocalculado ;;
  }
  dimension: mto_costonuevo {
    type: number
    sql: ${TABLE}.mto_costonuevo ;;
  }
  dimension: mto_medida {
    type: number
    sql: ${TABLE}.mto_medida ;;
  }
  dimension: mto_preciopublico {
    type: number
    sql: ${TABLE}.mto_preciopublico ;;
  }
  measure: count {
    type: count
  }
}
