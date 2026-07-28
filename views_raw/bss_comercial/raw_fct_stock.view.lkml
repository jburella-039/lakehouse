# =============================================================================
# RAW view: raw_fct_stock
# Capa CRUDA (dimensiones y claves; SIN medidas). Las metricas viven en la capa
# STG (fct_stock). Fuente: lakehouse-dev-483619.bss_comercial.vw_fct_stock
# (PRODUCCION COMPLETA, ~392 sucursales, 2023..2026). Usa nombres CRUDOS Oracle.
# Grano: fec_dia + id_sucursal + cd_sku. ID_TIE_DIA es TIMESTAMP.
# =============================================================================

view: raw_fct_stock {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.vw_fct_stock` ;;
  fields_hidden_by_default: yes

  dimension: pk {
    primary_key: yes
    type: string
    sql: CONCAT(FORMAT_TIMESTAMP('%Y%m%d', ${TABLE}.ID_TIE_DIA),'-',
                ${id_sucursal},'-',${cd_sku}) ;;
  }

  # ---------------------------------------------------------------------------
  # DIMENSIONES - claves de join
  # ---------------------------------------------------------------------------
  dimension: id_sucursal     { type: number sql: ${TABLE}.ID_SUC_SUCURSAL ;;        label: "Sucursal (ID)" }
  dimension: cd_sku          { type: number sql: ${TABLE}.ID_ART_CUF ;;             label: "SKU (Articulo)" }
  dimension: id_departamento { type: number sql: ${TABLE}.ID_ART_HISDEPARTAMENTO ;; }
  dimension: id_categoria    { type: number sql: ${TABLE}.ID_ART_HISCATEGORIA ;; }
  dimension: id_subcategoria { type: number sql: ${TABLE}.ID_ART_HISSUBCATEGORIA ;; }
  dimension: id_marca        { type: number sql: ${TABLE}.ID_ART_HISMARCA ;; }
  dimension: id_proveedor    { type: number sql: ${TABLE}.ID_PRO_HISPROVEEDOR ;;    label: "Proveedor (ID)" }

  # ---------------------------------------------------------------------------
  # TIEMPO (ID_TIE_DIA es TIMESTAMP)
  # ---------------------------------------------------------------------------
  dimension_group: dia {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.ID_TIE_DIA ;;
    label: "Fecha Stock"
  }

  # "Stock del ultimo dia" = la fila cae en el maximo fec_dia cargado en la fct.
  # Equivale a la vista StockDia sin materializar nada aparte.
  dimension: es_ultimo_dia {
    type: yesno
    sql: DATE(${TABLE}.ID_TIE_DIA) = (
           SELECT MAX(DATE(ID_TIE_DIA))
           FROM `lakehouse-dev-483619.bss_comercial.vw_fct_stock`
         ) ;;
    label: "Es ultimo dia?"
  }

  dimension: pertenece_surtido {
    type: yesno
    sql: ${TABLE}.FL_STK_PERTENECEASURTIDO = 1 ;;
    label: "Pertenece a Surtido?"
  }
}
