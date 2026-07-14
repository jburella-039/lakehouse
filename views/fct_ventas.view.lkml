# =============================================================================
# view: fct_ventas
# Hecho de ventas (nivel linea de comprobante) - BSS Comercial
# Fuente: lakehouse-dev-483619.bss_comercial.vw_fct_ventas
# (columnas identicas a bss_oracle.fct_ventas; validado 1:1 marzo 2026:
#  venta_neta, unidades, costo, tickets y filas coinciden exacto).
#
# Alineado al MAPEO_SSAS_a_LookML v5 (fct real de BigQuery):
#  - Venta neta s/IVA antes de desc = columna precalculada mto_totalsinivaantesdescuento
#    (equivale a [Vta $ T SIva Ant Desc] del cubo).
#  - Unidades = cnt_unidades ; Costo = mto_costo ; Margen $ = neto - costo.
#  - Ticket (resta stock): id_ventaunica viene NULL en la fct -> key interina por
#    combinacion; COALESCE prioriza id_ventaunica cuando se puebla.
#
# PENDIENTE (requiere joins de dimension, ver explore):
#  - Filtros por flags ID_TKT_ESVENTA / ID_TKT_RESTASTOCK (viven en TipoComprobante).
#    Las medidas base hoy NO los aplican; se agregan al wirear el join o al
#    denormalizar es_venta/resta_stock en el hecho (recomendacion del mapeo).
# =============================================================================

view: fct_ventas {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.vw_fct_ventas` ;;

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
  # DIMENSIONES - claves de join (a wirear en el explore)
  # ---------------------------------------------------------------------------
  dimension: id_sucursal       { type: number sql: ${TABLE}.id_sucursal ;;       label: "Sucursal (ID)" }
  dimension: id_caja           { type: number sql: ${TABLE}.id_caja ;;           label: "Caja" }
  dimension: id_tipocomprobante{ type: number sql: ${TABLE}.id_tipocomprobante ;; label: "Tipo Comprobante (ID)" }
  dimension: cd_nrocomprobante { type: number sql: ${TABLE}.cd_nrocomprobante ;;  label: "Nro Comprobante" }
  dimension: id_nroapertura    { type: number sql: ${TABLE}.id_nroapertura ;;     hidden: yes }
  dimension: cd_sku            { type: number sql: ${TABLE}.cd_sku ;;            label: "SKU (Articulo)" }
  dimension: id_obrasocial     { type: number sql: ${TABLE}.id_obrasocial ;;     label: "Obra Social (ID)" }
  dimension: id_proveedor      { type: number sql: ${TABLE}.id_proveedor ;;      label: "Proveedor (ID)" }
  dimension: id_origenventa    { type: number sql: ${TABLE}.id_origenventa ;;    label: "Origen Venta / Canal (ID)" hidden: yes }

  # Jerarquia de producto historica directa en la fct (alternativa al snowflake).
  dimension: id_departamento   { type: number sql: ${TABLE}.id_departamento ;;   label: "Departamento (ID)" }
  dimension: id_categoria      { type: number sql: ${TABLE}.id_categoria ;;      label: "Categoria (ID)" }
  dimension: id_subcategoria   { type: number sql: ${TABLE}.id_subcategoria ;;   label: "Subcategoria (ID)" }
  dimension: id_marca          { type: number sql: ${TABLE}.id_marca ;;          label: "Marca (ID)" }

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

  # Año como STRING para el filtro selector (dropdown). Un field_filter sobre el
  # year numerico (dia_year) renderiza un input numerico sin lista; este campo de
  # texto con suggestions fijas muestra el desplegable con los años.
  dimension: anio_sel {
    type: string
    sql: CAST(${dia_year} AS STRING) ;;
    label: "Año"
    suggestions: ["2026", "2025", "2024"]
  }

  dimension: num_hora { type: number sql: ${TABLE}.num_hora ;; label: "Hora del Dia" }

  # ---------------------------------------------------------------------------
  # MEASURES - base (Ventas / Unidades / Tickets)
  # ---------------------------------------------------------------------------
  # [Vta $ T SIva Ant Desc] - filtra ESVENTA=1 via join a dim_tipocomprobante
  measure: venta_neta {
    type: sum
    sql: ${TABLE}.mto_totalsinivaantesdescuento ;;
    filters: [dim_tipocomprobante.es_venta: "yes"]
    value_format_name: usd_0
    label: "Venta $ (s/IVA a/desc)"
    drill_fields: [detalle*]
  }

  # [Vta # T Unid Vend] - ESVENTA=1
  measure: unidades {
    type: sum
    sql: ${TABLE}.cnt_unidades ;;
    filters: [dim_tipocomprobante.es_venta: "yes"]
    value_format_name: decimal_0
    label: "Unidades Vendidas"
  }

  # [Vta # Cant Tickets (Resta Stock)] - RESTASTOCK=1 & ESVENTA=1
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
  # MEASURES - derivadas (margen y promedios)
  # ---------------------------------------------------------------------------
  # [Margen T $ SIva Ant Desc]
  measure: margen_pesos {
    type: number
    sql: ${venta_neta} - ${costo} ;;
    value_format_name: usd_0
    label: "Margen $ (s/IVA a/desc)"
  }

  # [Margen SIva Ant Desc] -> es %, no participacion
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

  # Participacion sobre el total del contexto (para los graficos de % del PBI).
  measure: pct_venta_total {
    type: percent_of_total
    sql: ${venta_neta} ;;
    label: "% Venta (participacion)"
  }

  measure: pct_tickets_total {
    type: percent_of_total
    sql: ${tickets} ;;
    label: "% Tickets (participacion)"
  }

  measure: pct_unidades_total {
    type: percent_of_total
    sql: ${unidades} ;;
    label: "% Unidades (participacion)"
  }

  # ---------------------------------------------------------------------------
  # MEASURES dinamicas por periodo (KPIs que responden al filtro Fecha)
  # El filtro Fecha del dashboard se mapea (listen) a filtro_fecha en las
  # tarjetas KPI. La version "_aa" aplica el MISMO rango pero sobre la fecha + 1
  # año (DATE_ADD), por lo que devuelve el mismo periodo del año anterior:
  # comparacion interanual dinamica (validada en BigQuery: marzo 26 vs 25 = +34.1%).
  # Estas medidas NO usan el filtro Fecha como filtro normal de la query (la
  # tarjeta escucha fecha -> filtro_fecha), porque la "_aa" necesita ver las
  # filas del año anterior, que un filtro normal sobre la fecha excluiria.
  # ---------------------------------------------------------------------------
  filter: filtro_fecha {
    type: date
    label: "Fecha (periodo KPI)"
  }

  # Patron documentado por Looker (timeframe vs timeframe analysis): el {% condition %}
  # va en una dimension yesno y las medidas se filtran por ella. (Ponerlo dentro del
  # sql de la medida daba Query error en BigQuery.) en_periodo = la fila cae en el rango
  # Fecha; en_periodo_aa = el dia + 1 año cae en el rango -> mismo periodo año anterior.
  # NOTA: filtro_fecha es un filter type: date que Looker trata como TIMESTAMP, por
  # lo que {% condition %} genera literales TIMESTAMP. El lado izquierdo debe ser
  # TIMESTAMP tambien (BigQuery no compara DATE >= TIMESTAMP). Se normaliza a la fecha
  # (DATE) y se reconvierte a TIMESTAMP(midnight UTC), mismo bucketing que usan las
  # tendencias/tablas (DATE(fec_dia)).
  dimension: en_periodo {
    hidden: yes
    type: yesno
    sql: {% condition filtro_fecha %} TIMESTAMP(DATE(${TABLE}.fec_dia)) {% endcondition %} ;;
  }
  dimension: en_periodo_aa {
    hidden: yes
    type: yesno
    sql: {% condition filtro_fecha %} TIMESTAMP(DATE_ADD(DATE(${TABLE}.fec_dia), INTERVAL 1 YEAR)) {% endcondition %} ;;
  }

  # Union del periodo seleccionado y su equivalente del año anterior. Se usa como
  # filtro duro (=yes) en tablas/KPIs para ACOTAR el scan a esas dos ventanas; sin
  # esto las medidas *_periodo agregan sobre toda la historia (count_distinct de
  # tickets no termina). Usa filtro_fecha via listen, igual que en_periodo.
  dimension: en_periodo_o_aa {
    hidden: yes
    type: yesno
    sql: ({% condition filtro_fecha %} TIMESTAMP(DATE(${TABLE}.fec_dia)) {% endcondition %})
      OR ({% condition filtro_fecha %} TIMESTAMP(DATE_ADD(DATE(${TABLE}.fec_dia), INTERVAL 1 YEAR)) {% endcondition %}) ;;
  }

  measure: venta_periodo {
    type: sum
    sql: ${TABLE}.mto_totalsinivaantesdescuento ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo: "yes"]
    value_format: "$#,##0.0,,,\"B\""
    label: "Venta $ (periodo)"
  }
  measure: venta_periodo_aa {
    type: sum
    sql: ${TABLE}.mto_totalsinivaantesdescuento ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo_aa: "yes"]
    value_format_name: usd_0
    label: "Venta $ (periodo año ant.)"
  }

  measure: tickets_periodo {
    type: count_distinct
    sql: ${ticket_key} ;;
    filters: [dim_tipocomprobante.resta_stock: "yes", dim_tipocomprobante.es_venta: "yes", en_periodo: "yes"]
    value_format: "#,##0.0,,\"M\""
    label: "Tickets (periodo)"
  }
  measure: tickets_periodo_aa {
    type: count_distinct
    sql: ${ticket_key} ;;
    filters: [dim_tipocomprobante.resta_stock: "yes", dim_tipocomprobante.es_venta: "yes", en_periodo_aa: "yes"]
    label: "Tickets (periodo año ant.)"
  }

  measure: unidades_periodo {
    type: sum
    sql: ${TABLE}.cnt_unidades ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo: "yes"]
    value_format: "#,##0.0,,\"M\""
    label: "Unidades (periodo)"
  }
  measure: unidades_periodo_aa {
    type: sum
    sql: ${TABLE}.cnt_unidades ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo_aa: "yes"]
    value_format_name: decimal_0
    label: "Unidades (periodo año ant.)"
  }

  measure: costo_periodo {
    type: sum
    sql: ${TABLE}.mto_costo ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo: "yes"]
    value_format_name: usd_0
    label: "Costo $ (periodo)"
  }
  measure: costo_periodo_aa {
    type: sum
    sql: ${TABLE}.mto_costo ;;
    filters: [dim_tipocomprobante.es_venta: "yes", en_periodo_aa: "yes"]
    value_format_name: usd_0
    label: "Costo $ (periodo año ant.)"
  }

  # Derivadas del periodo (margen y ratios), actual y año anterior.
  measure: margen_periodo {
    type: number
    sql: ${venta_periodo} - ${costo_periodo} ;;
    value_format: "$#,##0.0,,,\"B\""
    label: "Margen $ (periodo)"
  }
  measure: margen_periodo_aa {
    type: number
    sql: ${venta_periodo_aa} - ${costo_periodo_aa} ;;
    value_format_name: usd_0
    label: "Margen $ (periodo año ant.)"
  }
  measure: margen_pct_periodo {
    type: number
    sql: SAFE_DIVIDE(${venta_periodo} - ${costo_periodo}, NULLIF(${venta_periodo},0)) ;;
    value_format_name: percent_2
    label: "Margen % (periodo)"
  }
  measure: margen_pct_periodo_aa {
    type: number
    sql: SAFE_DIVIDE(${venta_periodo_aa} - ${costo_periodo_aa}, NULLIF(${venta_periodo_aa},0)) ;;
    value_format_name: percent_2
    label: "Margen % (periodo año ant.)"
  }
  measure: ticket_promedio_periodo {
    type: number
    sql: SAFE_DIVIDE(${venta_periodo}, NULLIF(${tickets_periodo},0)) ;;
    value_format_name: usd_0
    label: "Ticket Promedio (periodo)"
  }
  measure: ticket_promedio_periodo_aa {
    type: number
    sql: SAFE_DIVIDE(${venta_periodo_aa}, NULLIF(${tickets_periodo_aa},0)) ;;
    value_format_name: usd_0
    label: "Ticket Promedio (periodo año ant.)"
  }
  measure: unidades_por_ticket_periodo {
    type: number
    sql: SAFE_DIVIDE(${unidades_periodo}, NULLIF(${tickets_periodo},0)) ;;
    value_format_name: decimal_2
    label: "Unidades por Ticket (periodo)"
  }
  measure: unidades_por_ticket_periodo_aa {
    type: number
    sql: SAFE_DIVIDE(${unidades_periodo_aa}, NULLIF(${tickets_periodo_aa},0)) ;;
    value_format_name: decimal_2
    label: "Unidades por Ticket (periodo año ant.)"
  }

  # ---------------------------------------------------------------------------
  # MEASURES YoY (% de variacion vs mismo periodo del año anterior)
  # Reutilizables desde el explore. Variacion relativa = (actual - año ant) / año ant
  # sobre las medidas _periodo / _periodo_aa (que ya siguen el filtro Fecha via
  # filtro_fecha). En las tarjetas KPI se usan como campo de comparacion (single_value
  # comparison_type: change): muestran el % con flecha verde/roja segun el signo.
  # Margen %: variacion en PUNTOS porcentuales (diferencia), no relativa.
  # ---------------------------------------------------------------------------
  measure: venta_yoy {
    type: number
    sql: SAFE_DIVIDE(${venta_periodo} - ${venta_periodo_aa}, NULLIF(${venta_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Ventas Var % (YoY)"
  }
  measure: tickets_yoy {
    type: number
    sql: SAFE_DIVIDE(${tickets_periodo} - ${tickets_periodo_aa}, NULLIF(${tickets_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Tickets Var % (YoY)"
  }
  measure: unidades_yoy {
    type: number
    sql: SAFE_DIVIDE(${unidades_periodo} - ${unidades_periodo_aa}, NULLIF(${unidades_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Unidades Var % (YoY)"
  }
  measure: ticket_promedio_yoy {
    type: number
    sql: SAFE_DIVIDE(${ticket_promedio_periodo} - ${ticket_promedio_periodo_aa}, NULLIF(${ticket_promedio_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Ticket Promedio Var % (YoY)"
  }
  measure: unidades_por_ticket_yoy {
    type: number
    sql: SAFE_DIVIDE(${unidades_por_ticket_periodo} - ${unidades_por_ticket_periodo_aa}, NULLIF(${unidades_por_ticket_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Unidades por Ticket Var % (YoY)"
  }
  measure: margen_yoy {
    type: number
    sql: SAFE_DIVIDE(${margen_periodo} - ${margen_periodo_aa}, NULLIF(${margen_periodo_aa}, 0)) ;;
    value_format_name: percent_1
    label: "Margen $ Var % (YoY)"
  }
  # Margen %: diferencia en puntos porcentuales (x100 para mostrar "pp").
  measure: margen_pct_yoy {
    type: number
    sql: (${margen_pct_periodo} - ${margen_pct_periodo_aa}) * 100 ;;
    value_format: "0.00\" pp\""
    label: "Margen % Var (pp YoY)"
  }

  set: detalle {
    fields: [venta_date, id_sucursal, cd_nrocomprobante, cd_sku,
             id_categoria, id_marca, tipo_cobertura, unidades, venta_neta, margen_pesos]
  }
}
