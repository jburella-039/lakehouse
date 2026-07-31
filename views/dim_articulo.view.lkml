# dim_articulo - maestro de articulo (producto). Clave: cd_sku.
# Provee descripcion de producto y las claves de la jerarquia (snowflake).
view: dim_articulo {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_articulo` ;;

  dimension: cd_sku { primary_key: yes type: number sql: ${TABLE}.cd_sku ;; label: "SKU" }

  dimension: descripcion { type: string sql: ${TABLE}.dsc_sku ;; label: "Descripcion" }

  # "220246 - OZEMPIC 1MG/DOSIS X 3ML" (como en el Power BI)
  dimension: producto {
    type: string
    sql: CONCAT(CAST(${cd_sku} AS STRING), ' - ', ${TABLE}.dsc_sku) ;;
    label: "Producto (SKU - Descripcion)"
  }

  # claves de join hacia la jerarquia (ocultas; se usan en el explore)
  dimension: id_marca        { hidden: yes type: number sql: ${TABLE}.id_marca ;; }
  dimension: id_categoria    { hidden: yes type: number sql: ${TABLE}.id_categoria ;; }
  dimension: id_subcategoria { hidden: yes type: number sql: ${TABLE}.id_subcategoria ;; }
  dimension: id_departamento { hidden: yes type: number sql: ${TABLE}.id_departamento ;; }

  # Marca Propia REPRODUCIBLE: sector "Marca Propia" = IdSector 3 (trd_comercial.sector).
  # Venta marzo 2026 del sector 3 = 8.2% (coincide con el 8.1% del Power BI).
  # (El flag EsMarcaPropia esta despoblado y id_marcapropia es un id-centinela, no sirven.)
  dimension: id_sector { hidden: yes type: number sql: ${TABLE}.id_sector ;; }
  dimension: marca_propia {
    type: string
    sql: CASE WHEN ${TABLE}.id_sector = 3 THEN 'Marca Propia' ELSE 'Resto' END ;;
    label: "Marca Propia"
  }
  dimension: id_marcapropia { hidden: yes type: number sql: ${TABLE}.id_marcapropia ;; }

  dimension: es_ecommerce {
    type: yesno
    sql: ${TABLE}.flg_esecommerce = '1' ;;
    label: "Ecommerce?"
  }
}
