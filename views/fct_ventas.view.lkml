# =============================================================================
# view: fct_ventas
# Hecho de ventas (nivel línea de comprobante) — BSS Oracle
# Fuente: lakehouse-dev-483619.bss_oracle.fct_ventas (~1.8 mil M filas)
#
# Alineado al MAPEO_SSAS_a_LookML v5 (fct real de BigQuery):
#  - Venta neta s/IVA antes de desc = columna precalculada mto_totalsinivaantesdescuento
#    (equivale a [Vta $ T SIva Ant Desc] del cubo).
#  - Unidades = cnt_cantidad ; Costo = mto_costo ; Margen $ = neto - costo.
#  - Ticket (resta stock): id_ventaunica viene NULL en la fct -> key interina por
#    combinación; COALESCE prioriza id_ventaunica cuando se puebla.
#
# PENDIENTE (requiere joins de dimensión, ver explore):
#  - Filtros por flags ID_TKT_ESVENTA / ID_TKT_RESTASTOCK (viven en TipoComprobante).
#    Las medidas base hoy NO los aplican; se agregan al wirear el join o al
#    denormalizar es_venta/resta_stock en el hecho (recomendación del mapeo).
# =============================================================================

view: fct_ventas {
  sql_table_name: `lakehouse-dev-483619.bss_oracle.fct_ventas` ;;

  # ---------------------------------------------------------------------------
  # CLAVES
  # ---------------------------------------------------------------------------
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${id_sucursal},'-',${id_caja},'-',${id_tipocomprobante},'-',
                ${cd_nrocomprobante},'-',${cd_sku}) ;;
  }

  # Key de ticket (resta stock). Prioriza id_ventaunica cuando exista.
  dimension: ticket_key {
    hidden: yes
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
  # DIMENSIONES — claves de join (a wirear en el explore)
  # ---------------------------------------------------------------------------
  dimension: id_sucursal       { type: number sql: ${TABLE}.id_sucursal ;;       label: "Sucursal (ID)" }
  dimension: id_caja           { type: number sql: ${TABLE}.id_caja ;;           label: "Caja" }
  dimension: id_tipocomprobante{ type: number sql: ${TABLE}.id_tipocomprobante ;; label: "Tipo Comprobante (ID)" }
  dimension: cd_nrocomprobante { type: number sql: ${TABLE}.cd_nrocomprobante ;;  label: "Nro Comprobante" }
  dimension: id_nroapertura    { type: number sql: ${TABLE}.id_nroapertura ;;     hidden: yes }
  dimension: cd_sku            { type: number sql: ${TABLE}.cd_sku ;;            label: "SKU (Artículo)" }
  dimension: id_obrasocial     { type: number sql: ${TABLE}.id_obrasocial ;;     label: "Obra Social (ID)" }
  dimension: id_proveedor      { type: number sql: ${TABLE}.id_proveedor ;;      label: "Proveedor (ID)" }

  # Jerarquía de producto histórica directa en la fct (alternativa al snowflake).
  dimension: id_departamento   { type: number sql: ${TABLE}.id_departamento ;;   label: "Departamento (ID)" }
  dimension: id_categoria      { type: number sql: ${TABLE}.id_categoria ;;      label: "Categoría (ID)" }
  dimension: id_subcategoria   { type: number sql: ${TABLE}.id_subcategoria ;;   label: "Subcategoría (ID)" }
  dimension: id_marca          { type: number sql: ${TABLE}.id_marca ;;          label: "Marca (ID)" }

  # ---------------------------------------------------------------------------
  # DIMENSIONES — cliente / cobertura
  # ---------------------------------------------------------------------------
  dimension: id_cliente { type: number sql: ${TABLE}.id_cliente ;; label: "Cliente (ID)" }

  dimension: cliente_identificado {
    type: yesno
    sql: ${TABLE}.id_cliente <> -1 AND ${TABLE}.id_cliente IS NOT NULL ;;
    label: "¿Cliente Identificado?"
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

  # fec_dia (día contable) — usada para join a la dim Fecha y para el ticket_key.
  dimension_group: dia {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.fec_dia ;;
    label: "Día Contable"
  }

  dimension: num_hora { type: number sql: ${TABLE}.num_hora ;; label: "Hora del Día" }

  # ---------------------------------------------------------------------------
  # MEASURES — base (Ventas / Unidades / Tickets)
  # ---------------------------------------------------------------------------
  # [Vta $ T SIva Ant Desc] — filtra ESVENTA=1 vía join a dim_tipocomprobante
  measure: venta_neta {
    type: sum
    sql: ${TABLE}.mto_totalsinivaantesdescuento ;;
    filters: [dim_tipocomprobante.es_venta: "yes"]
    value_format_name: usd_0
    label: "Venta $ (s/IVA a/desc)"
    drill_fields: [detalle*]
  }

  # [Vta # T Unid Vend] — ESVENTA=1
  measure: unidades {
    type: sum
    sql: ${TABLE}.cnt_cantidad ;;
    filters: [dim_tipocomprobante.es_venta: "yes"]
    value_format_name: decimal_0
    label: "Unidades Vendidas"
  }

  # [Vta # Cant Tickets (Resta Stock)] — RESTASTOCK=1 & ESVENTA=1
  measure: tickets {
    type: count_distinct
    sql: ${ticket_key} ;;
    filters: [dim_tipocomprobante.resta_stock: "yes", dim_tipocomprobante.es_venta: "yes"]
    label: "Tickets (Resta Stock)"
  }

  measure: costo {
    type: sum
    sql: ${TABLE}.mto_costo ;;
    filters: [dim_tipocomprobante.es_venta: "yes"]
    value_format_name: usd_0
    label: "Costo $"
  }

  # ---------------------------------------------------------------------------
  # MEASURES — derivadas (margen y promedios)
  # ---------------------------------------------------------------------------
  # [Margen T $ SIva Ant Desc]
  measure: margen_pesos {
    type: number
    sql: ${venta_neta} - ${costo} ;;
    value_format_name: usd_0
    label: "Margen $ (s/IVA a/desc)"
  }

  # [Margen SIva Ant Desc] -> es %, no participación
  measure: margen_pct {
    type: number
    sql: SAFE_DIVIDE(${venta_neta} - ${costo}, NULLIF(${venta_neta},0)) ;;
    value_format_name: percent_2
    label: "Margen %"
  }

  # [Ticket Promedio]
  measure: ticket_promedio {
    type: number
    sql: SAFE_DIVIDE(${venta_neta}, NULLIF(${tickets},0)) ;;
    value_format_name: usd_0
    label: "Ticket Promedio"
  }

  # [Unidades por Ticket]
  measure: unidades_por_ticket {
    type: number
    sql: SAFE_DIVIDE(${unidades}, NULLIF(${tickets},0)) ;;
    value_format_name: decimal_2
    label: "Unidades por Ticket"
  }

  # Participación sobre el total del contexto (para los gráficos de % del PBI).
  measure: pct_venta_total {
    type: percent_of_total
    sql: ${venta_neta} ;;
    label: "% Venta (participación)"
  }

  set: detalle {
    fields: [venta_date, id_sucursal, cd_nrocomprobante, cd_sku,
             id_categoria, id_marca, tipo_cobertura, unidades, venta_neta, margen_pesos]
  }
}
