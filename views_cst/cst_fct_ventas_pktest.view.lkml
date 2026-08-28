# =============================================================================
# view: cst_fct_ventas_pktest  (VISTA DE PRUEBA - NO productiva)
# Objetivo (pedido de Luca): validar que la PK nativa de BigQuery id_venta
# (agregada por Alex en la tabla base fct_ventas) da EXACTAMENTE el mismo conteo
# de tickets que la PK que hoy calculamos en Looker (hash FARM_FINGERPRINT de 6
# campos). Las dos claves conviven; no se borra ni modifica nada de produccion.
#
# Lee la TABLA BASE bss_comercial.fct_ventas (no la vista vw_fct_ventas) porque
# id_venta todavia no esta expuesta en la vista logica. Cuando el equipo de datos
# publique id_venta en vw_fct_ventas, el cambio productivo se hace en bas_fct_ventas.
#
# Validacion BigQuery (marzo 2026): COUNT(DISTINCT id_venta)=32.742,
# COUNT(DISTINCT hash6)=32.742, 0 NULLs -> coincidencia exacta 1:1.
# =============================================================================
view: cst_fct_ventas_pktest {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.fct_ventas` ;;

  # PK de linea (grano de renglon) - solo para primary_key del explore.
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.id_sucursal AS STRING),'-',CAST(${TABLE}.id_caja AS STRING),'-',
                CAST(${TABLE}.id_tipocomprobante AS STRING),'-',CAST(${TABLE}.cd_nrocomprobante AS STRING),'-',
                CAST(${TABLE}.cd_sku AS STRING),'-',FORMAT_DATE('%Y%m%d', ${TABLE}.fec_dia)) ;;
  }

  # ---- PK ACTUAL: hash de cabecera (6 campos), lo que usamos hoy en produccion.
  dimension: hk_vta_venta_hash {
    hidden: yes
    type: number
    sql: FARM_FINGERPRINT(CONCAT(
           CAST(${TABLE}.id_sucursal        AS STRING),'-',
           CAST(${TABLE}.id_caja            AS STRING),'-',
           CAST(${TABLE}.id_tipocomprobante AS STRING),'-',
           CAST(${TABLE}.cd_nrocomprobante  AS STRING),'-',
           FORMAT_DATE('%Y%m%d', ${TABLE}.fec_dia),'-',
           CAST(${TABLE}.id_nroapertura     AS STRING))) ;;
  }

  # ---- PK NUEVA: id_venta nativa de BigQuery (Alex).
  dimension: id_venta {
    hidden: yes
    type: number
    sql: ${TABLE}.id_venta ;;
  }

  # Clave de join para los flags ESVENTA / RESTASTOCK (mismo criterio que produccion).
  dimension: id_tipocomprobante {
    hidden: yes
    type: number
    sql: ${TABLE}.id_tipocomprobante ;;
  }

  # fec_dia es DATE en la tabla base -> datatype: date para que Looker genere
  # literales DATE en el filtro (si no, arma TIMESTAMP y BigQuery falla:
  # "No matching signature for operator >= for argument types: DATE, TIMESTAMP").
  dimension_group: dia {
    type: time
    datatype: date
    convert_tz: no
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_dia ;;
    label: "Fecha"
  }

  # ---------------------------------------------------------------------------
  # MEASURES TEST - misma metrica (Tickets) por las dos PKs. Mismos filtros que
  # la medida productiva 'tickets' (es_venta=1 y resta_stock=1).
  # ---------------------------------------------------------------------------
  measure: tickets_hash_TEST {
    type: count_distinct
    sql: ${hk_vta_venta_hash} ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes"]
    value_format_name: decimal_0
    label: "Tickets (PK hash actual) TEST"
  }

  measure: tickets_idventa_TEST {
    type: count_distinct
    sql: ${id_venta} ;;
    filters: [dim_tipocomprobante.es_venta: "yes", dim_tipocomprobante.resta_stock: "yes"]
    value_format_name: decimal_0
    label: "Tickets (PK id_venta BQ) TEST"
  }

  # Debe dar 0 si las dos PKs son equivalentes.
  measure: tickets_diff_TEST {
    type: number
    sql: ${tickets_idventa_TEST} - ${tickets_hash_TEST} ;;
    value_format_name: decimal_0
    label: "Diferencia Tickets (id_venta - hash) TEST"
  }
}
