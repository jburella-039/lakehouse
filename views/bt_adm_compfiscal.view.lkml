view: bt_adm_compfiscal {
  sql_table_name: `bss_oracle.BT_ADM_COMPFISCAL` ;;

  dimension: cuit_comprador {
    type: string
    sql: ${TABLE}.CUIT_COMPRADOR ;;
  }
  dimension: fc_cpf_basegravada {
    type: number
    sql: ${TABLE}.FC_CPF_BASEGRAVADA ;;
  }
  dimension: fc_cpf_basenogravada {
    type: number
    sql: ${TABLE}.FC_CPF_BASENOGRAVADA ;;
  }
  dimension: fc_cpf_cantidad {
    type: number
    sql: ${TABLE}.FC_CPF_CANTIDAD ;;
  }
  dimension: fc_cpf_costototal {
    type: number
    sql: ${TABLE}.FC_CPF_COSTOTOTAL ;;
  }
  dimension: fc_cpf_impuestovideo {
    type: number
    sql: ${TABLE}.FC_CPF_IMPUESTOVIDEO ;;
  }
  dimension: fc_cpf_iva {
    type: number
    sql: ${TABLE}.FC_CPF_IVA ;;
  }
  dimension: fc_cpf_montototal {
    type: number
    sql: ${TABLE}.FC_CPF_MONTOTOTAL ;;
  }
  dimension: fc_cpf_percepcioniva10_5 {
    type: number
    sql: ${TABLE}.FC_CPF_PERCEPCIONIVA10_5 ;;
  }
  dimension: fc_cpf_percepcioniva21 {
    type: number
    sql: ${TABLE}.FC_CPF_PERCEPCIONIVA21 ;;
  }
  dimension: fc_cpf_tasaimpuestovideo {
    type: number
    sql: ${TABLE}.FC_CPF_TASAIMPUESTOVIDEO ;;
  }
  dimension: fc_cpf_tasaiva {
    type: number
    sql: ${TABLE}.FC_CPF_TASAIVA ;;
  }
  dimension: id_art_cuf {
    type: number
    sql: ${TABLE}.ID_ART_CUF ;;
  }
  dimension: id_art_hiscategoria {
    type: number
    sql: ${TABLE}.ID_ART_HISCATEGORIA ;;
  }
  dimension: id_art_hisdepartamento {
    type: number
    sql: ${TABLE}.ID_ART_HISDEPARTAMENTO ;;
  }
  dimension: id_art_hismarca {
    type: number
    sql: ${TABLE}.ID_ART_HISMARCA ;;
  }
  dimension: id_art_hissubcategoria {
    type: number
    sql: ${TABLE}.ID_ART_HISSUBCATEGORIA ;;
  }
  dimension: id_cpf_cai {
    type: string
    sql: ${TABLE}.ID_CPF_CAI ;;
  }
  dimension: id_cpf_canthojas {
    type: number
    sql: ${TABLE}.ID_CPF_CANTHOJAS ;;
  }
  dimension_group: id_cpf_fecha {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_CPF_FECHA ;;
  }
  dimension: id_cpf_nrocomprobante {
    type: number
    sql: ${TABLE}.ID_CPF_NROCOMPROBANTE ;;
  }
  dimension: id_cpf_nrocontrolador {
    type: number
    sql: ${TABLE}.ID_CPF_NROCONTROLADOR ;;
  }
  dimension: id_cpf_nrohoja {
    type: number
    sql: ${TABLE}.ID_CPF_NROHOJA ;;
  }
  dimension: id_cpf_porcpercepcioniva {
    type: number
    sql: ${TABLE}.ID_CPF_PORCPERCEPCIONIVA ;;
  }
  dimension: id_etl_cargadatos {
    type: number
    sql: ${TABLE}.ID_ETL_CARGADATOS ;;
  }
  dimension: id_pro_hisproveedor {
    type: number
    sql: ${TABLE}.ID_PRO_HISPROVEEDOR ;;
  }
  dimension: id_pro_razonsocial {
    type: number
    sql: ${TABLE}.ID_PRO_RAZONSOCIAL ;;
  }
  dimension: id_rrh_empleado {
    type: number
    sql: ${TABLE}.ID_RRH_EMPLEADO ;;
  }
  dimension: id_suc_sucursal {
    type: number
    sql: ${TABLE}.ID_SUC_SUCURSAL ;;
  }
  dimension_group: id_tie_dia {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.ID_TIE_DIA ;;
  }
  dimension: id_tie_mes {
    type: number
    sql: ${TABLE}.ID_TIE_MES ;;
  }
  dimension: id_tkt_tipocomprobante {
    type: number
    sql: ${TABLE}.ID_TKT_TIPOCOMPROBANTE ;;
  }
  dimension: id_trf_nrocomprobante {
    type: number
    sql: ${TABLE}.ID_TRF_NROCOMPROBANTE ;;
  }
  measure: count {
    type: count
  }
}
