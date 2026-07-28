# =============================================================================
# RAW view: raw_dim_articulo
# Capa CRUDA. Fuente: lakehouse-dev-483619.bss_comercial.dim_articulo
# Maestro de articulo (producto). Clave: cd_sku. Provee descripcion y las claves
# de la jerarquia (snowflake).
# =============================================================================

view: raw_dim_articulo {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_articulo` ;;
  fields_hidden_by_default: yes

  dimension: cd_sku { primary_key: yes type: number sql: ${TABLE}.cd_sku ;; label: "SKU" }

  dimension: descripcion { type: string sql: ${TABLE}.dsc_sku ;; label: "Descripcion" }

  # "220246 - OZEMPIC 1MG/DOSIS X 3ML" (como en el Power BI)
  dimension: producto {
    type: string
    sql: CONCAT(CAST(${cd_sku} AS STRING), ' - ', ${TABLE}.dsc_sku) ;;
    label: "Producto (SKU - Descripcion)"
  }

  # Claves de join hacia la jerarquia (se usan en el explore).
  dimension: id_marca        { type: number sql: ${TABLE}.id_marca ;; }
  dimension: id_categoria    { type: number sql: ${TABLE}.id_categoria ;; }
  dimension: id_subcategoria { type: number sql: ${TABLE}.id_subcategoria ;; }
  dimension: id_departamento { type: number sql: ${TABLE}.id_departamento ;; }

  # Marca Propia REPRODUCIBLE: sector "Marca Propia" = IdSector 3 (trd_comercial.sector).
  # Venta marzo 2026 del sector 3 = 8.2% (coincide con el 8.1% del Power BI).
  dimension: id_sector { type: number sql: ${TABLE}.id_sector ;; }
  dimension: marca_propia {
    type: string
    sql: CASE WHEN ${TABLE}.id_sector = 3 THEN 'Marca Propia' ELSE 'Resto' END ;;
    label: "Marca Propia"
  }
  dimension: id_marcapropia { type: number sql: ${TABLE}.id_marcapropia ;; }

  dimension: es_ecommerce {
    type: yesno
    sql: ${TABLE}.flg_esecommerce = '1' ;;
    label: "Ecommerce?"
  }
}
