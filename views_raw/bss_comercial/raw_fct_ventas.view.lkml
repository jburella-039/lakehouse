# =============================================================================
# RAW view: raw_fct_ventas
# Capa CRUDA (dimensiones y claves; SIN medidas). Las metricas viven en la capa
# STG (fct_ventas). Fuente: lakehouse-dev-483619.bss_comercial.vw_fct_ventas
# (columnas identicas a bss_oracle.fct_ventas; validado 1:1 marzo 2026).
#
# Ticket (resta stock): id_ventaunica viene NULL en la fct -> key interina por
# combinacion; COALESCE prioriza id_ventaunica cuando se puebla.
# =============================================================================

view: raw_fct_ventas {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.vw_fct_ventas` ;;
  fields_hidden_by_default: yes

  # ---------------------------------------------------------------------------
  # CLAVES
  # ---------------------------------------------------------------------------
  dimension: pk {
    primary_key: yes
    type: string
    sql: CONCAT(${id_sucursal},'-',${id_caja},'-',${id_tipocomprobante},'-',
                ${cd_nrocomprobante},'-',${cd_sku}) ;;
  }

  # Key de ticket (resta stock). Prioriza id_ventaunica cuando exista.
  dimension: ticket_key {
    type: string
    sql: COALESCE(
            CAST(${TABLE}.id_ventaunica AS STRING),
            CONCAT(${id_sucursal},'-',${id_caja},'-',${id_tipocomprobante},'-',
                   ${cd_nrocomprobante},'-',
                   FORMAT_TIMESTAMP('%Y%m%d', ${TABLE}.fec_dia),'-',
                   CAST(${TABLE}.id_nroapertura AS STRING))
         ) ;;
  }

  # ---------------------------------------------------------------------------
  # DIMENSIONES - claves de join (a wirear en el explore)
  # ---------------------------------------------------------------------------
  dimension: id_sucursal        { type: number sql: ${TABLE}.id_sucursal ;;        label: "Sucursal (ID)" }
  dimension: id_caja            { type: number sql: ${TABLE}.id_caja ;;            label: "Caja" }
  dimension: id_tipocomprobante { type: number sql: ${TABLE}.id_tipocomprobante ;; label: "Tipo Comprobante (ID)" }
  dimension: cd_nrocomprobante  { type: number sql: ${TABLE}.cd_nrocomprobante ;;  label: "Nro Comprobante" }
  dimension: id_nroapertura     { type: number sql: ${TABLE}.id_nroapertura ;; }
  dimension: cd_sku             { type: number sql: ${TABLE}.cd_sku ;;             label: "SKU (Articulo)" }
  dimension: id_obrasocial      { type: number sql: ${TABLE}.id_obrasocial ;;      label: "Obra Social (ID)" }
  dimension: id_proveedor       { type: number sql: ${TABLE}.id_proveedor ;;       label: "Proveedor (ID)" }
  dimension: id_origenventa     { type: number sql: ${TABLE}.id_origenventa ;;     label: "Origen Venta / Canal (ID)" }

  # Jerarquia de producto historica directa en la fct (alternativa al snowflake).
  dimension: id_departamento { type: number sql: ${TABLE}.id_departamento ;; label: "Departamento (ID)" }
  dimension: id_categoria    { type: number sql: ${TABLE}.id_categoria ;;    label: "Categoria (ID)" }
  dimension: id_subcategoria { type: number sql: ${TABLE}.id_subcategoria ;; label: "Subcategoria (ID)" }
  dimension: id_marca        { type: number sql: ${TABLE}.id_marca ;;        label: "Marca (ID)" }

  # ---------------------------------------------------------------------------
  # DIMENSIONES - cliente / cobertura
  # ---------------------------------------------------------------------------
  dimension: id_cliente { type: number sql: ${TABLE}.id_cliente ;; label: "Cliente (ID)" }

  dimension: cliente_identificado {
    type: yesno
    sql: ${TABLE}.id_cliente <> -1 AND ${TABLE}.id_cliente IS NOT NULL ;;
    label: "Cliente Identificado?"
  }

  dimension: tipo_cobertura {
    type: string
    sql: CASE WHEN ${TABLE}.id_obrasocial IS NULL OR ${TABLE}.id_obrasocial <= 0
              THEN 'Particular' ELSE 'Obra Social / Coseguro' END ;;
    label: "Tipo de Cobertura"
  }

  # ---------------------------------------------------------------------------
  # TIEMPO
  # ---------------------------------------------------------------------------
  dimension_group: venta {
    type: time
    timeframes: [raw, time, hour_of_day, date, day_of_week, week, month, month_name, quarter, year]
    sql: ${TABLE}.fec_venta ;;
    label: "Fecha de Venta"
  }

  # fec_dia (dia contable) - usada para join a la dim Fecha y para el ticket_key.
  dimension_group: dia {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_dia ;;
    label: "Fecha"
  }

  # Año como STRING para el filtro selector (dropdown).
  dimension: anio_sel {
    type: string
    sql: CAST(${dia_year} AS STRING) ;;
    label: "Año"
    suggestions: ["2026", "2025", "2024"]
  }

  dimension: num_hora { type: number sql: ${TABLE}.num_hora ;; label: "Hora del Dia" }
}
