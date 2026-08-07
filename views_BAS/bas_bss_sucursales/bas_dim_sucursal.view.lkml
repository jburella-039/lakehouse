view: bas_dim_sucursal {
  sql_table_name: `lakehouse-dev-483619.bss_sucursales.dim_sucursal` ;;
  fields_hidden_by_default: yes

  dimension: cd_codigopostal {
    type: string
    sql: ${TABLE}.cd_codigopostal ;;
  }
  dimension: cd_cuentacontableobrasocial {
    type: string
    sql: ${TABLE}.cd_cuentacontableobrasocial ;;
  }
  dimension: cd_cuit {
    type: string
    sql: ${TABLE}.cd_cuit ;;
  }
  dimension: cd_sucursal {
    type: number
    sql: ${TABLE}.cd_sucursal ;;
  }
  dimension: cnt_metrocuadradosalon {
    type: number
    sql: ${TABLE}.cnt_metrocuadradosalon ;;
  }
  dimension: cnt_metrocuadradototal {
    type: number
    sql: ${TABLE}.cnt_metrocuadradototal ;;
  }
  dimension: cnt_puntodeventa {
    type: number
    sql: ${TABLE}.cnt_puntodeventa ;;
  }
  dimension: cnt_puntodeventafarmacia {
    type: number
    sql: ${TABLE}.cnt_puntodeventafarmacia ;;
  }
  dimension: dir_latitud {
    type: string
    sql: ${TABLE}.dir_latitud ;;
  }
  dimension: dir_longitud {
    type: string
    sql: ${TABLE}.dir_longitud ;;
  }
  dimension: dir_sucursal {
    type: string
    sql: ${TABLE}.dir_sucursal ;;
  }
  dimension: dsc_sucursal {
    type: string
    sql: ${TABLE}.dsc_sucursal ;;
  }
  dimension: dsc_sucursalcorta {
    type: string
    sql: ${TABLE}.dsc_sucursalcorta ;;
  }
  dimension_group: fec_alta {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_alta ;;
  }
  dimension_group: fec_apertura {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fec_apertura ;;
  }
  dimension: flg_abierto24hs {
    type: string
    sql: ${TABLE}.flg_abierto24hs ;;
  }
  dimension: flg_escapital {
    type: number
    sql: ${TABLE}.flg_escapital ;;
  }
  dimension: flg_escdf {
    type: number
    sql: ${TABLE}.flg_escdf ;;
  }
  dimension: flg_manejaobrasocial {
    type: number
    sql: ${TABLE}.flg_manejaobrasocial ;;
  }
  dimension: flg_nivelmadurez {
    type: number
    sql: ${TABLE}.flg_nivelmadurez ;;
  }
  dimension: id_ciudad {
    type: number
    sql: ${TABLE}.id_ciudad ;;
  }
  dimension: id_cluster {
    type: number
    sql: ${TABLE}.id_cluster ;;
  }
  dimension: id_clusterprecio {
    type: number
    sql: ${TABLE}.id_clusterprecio ;;
  }
  dimension: id_clustersalud {
    type: number
    sql: ${TABLE}.id_clustersalud ;;
  }
  dimension: id_empresa {
    type: number
    sql: ${TABLE}.id_empresa ;;
  }
  dimension: id_enterecaudador {
    type: number
    sql: ${TABLE}.id_enterecaudador ;;
  }
  dimension: id_estado {
    type: number
    sql: ${TABLE}.id_estado ;;
  }
  dimension: id_fiscal {
    type: number
    sql: ${TABLE}.id_fiscal ;;
  }
  dimension: id_formato {
    type: number
    sql: ${TABLE}.id_formato ;;
  }
  dimension: id_grupocomparable {
    type: number
    sql: ${TABLE}.id_grupocomparable ;;
  }
  dimension: id_pais {
    type: number
    sql: ${TABLE}.id_pais ;;
  }
  dimension: id_provincia {
    type: number
    sql: ${TABLE}.id_provincia ;;
  }
  dimension: id_region {
    type: number
    sql: ${TABLE}.id_region ;;
  }
  dimension: id_sucursal {
    type: number
    sql: ${TABLE}.id_sucursal ;;
  }
  dimension: id_tiporelacion {
    type: number
    sql: ${TABLE}.id_tiporelacion ;;
  }
  dimension: id_tiposucursal {
    type: number
    sql: ${TABLE}.id_tiposucursal ;;
  }
  dimension: pct_iibb {
    type: number
    sql: ${TABLE}.pct_iibb ;;
  }
  dimension: tel_sucursal {
    type: string
    sql: ${TABLE}.tel_sucursal ;;
  }
  measure: count {
    type: count
  }
}
