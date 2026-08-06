# =============================================================================
# FND view: fnd_fct_ventas  (capa fundacion)
# Capa CRUDA (dimensiones y claves; SIN medidas). Las metricas viven en la capa
# MRT (mrt_fct_ventas).
#
# CLAVE DE TICKET: se toma id_venta NATIVA de la vista vw_fct_ventas (INT64). Ya
# NO se calcula la PK en Looker. Antes se derivaba hk_vta_venta con
# FARM_FINGERPRINT de 6 campos de cabecera; se validó biyección 1:1 exacta entre
# id_venta y ese hash sobre la vista (0 NULLs en 693M filas, 2023-2026) y se
# reemplazó. Tickets = COUNT(DISTINCT id_venta): menos bytes y menos CPU que el
# hash (id_venta escanea 1 columna vs 6 y no computa nada).
#
# PDT (performance): se materializa la vista como derived_table persistido por el
# datagroup diario, particionado por fec_dia y clusterizado por las claves de
# cabecera. Mejora los group-by y el filtrado del dashboard vs leer la vista en
# vivo sobre bss_oracle.fct_ventas. El SELECT es un passthrough (SELECT f.*):
# id_venta ya viene en la vista, NO se calcula ningun hash. Requiere PDTs
# habilitados en la conexion (dataset scratch looker_scratch en southamerica-east1).
# fec_dia es TIMESTAMP en la vista -> el PDT queda igual y nada aguas abajo cambia.
# =============================================================================

view: fnd_fct_ventas {
  derived_table: {
    sql:
      SELECT f.*
      FROM `lakehouse-dev-483619.bss_comercial.vw_fct_ventas` AS f ;;
    datagroup_trigger: venta_integral_datagroup
    partition_keys: ["fec_dia"]
    cluster_keys: ["id_sucursal", "id_tipocomprobante", "cd_nrocomprobante"]
  }
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

  # Clave de ticket NATIVA de BigQuery (INT64). Reemplaza al hash que antes se
  # calculaba en Looker (FARM_FINGERPRINT de 6 campos). Ya NO se genera la PK en
  # Looker: se toma id_venta directo de la vista vw_fct_ventas. Validado 1:1 sobre
  # la vista (marzo 2026 y todo el historico 2023-2026): COUNT(DISTINCT id_venta) =
  # COUNT(DISTINCT hash6) = biyeccion exacta, 0 NULLs en 693M filas. Las medidas de
  # Tickets hacen COUNT(DISTINCT id_venta).
  dimension: id_venta {
    type: number
    sql: ${TABLE}.id_venta ;;
  }

  # Key de ticket legacy (string). Se conserva para drill/compatibilidad; las
  # medidas ya no la usan (usan id_venta). Ahora es el id_venta nativo casteado a
  # string (id_ventaunica quedaba 100% NULL en la vista, no servia).
  dimension: ticket_key {
    type: string
    sql: CAST(${TABLE}.id_venta AS STRING) ;;
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
