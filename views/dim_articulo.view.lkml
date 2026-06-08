# dim_articulo - maestro de articulo (producto). Clave: cd_sku.
# Provee descripcion de producto y las claves de la jerarquia (snowflake).
view: dim_articulo {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_articulo` ;;

  dimension: cd_sku { primary_key: yes type: number sql: ${TABLE}.cd_sku ;; label: "SKU" }

  dimension: descripcion { type: string sql: ${TABLE}.dsc_cuf ;; label: "Descripcion" }

  # "220246 - OZEMPIC 1MG/DOSIS X 3ML" (como en el Power BI)
  dimension: producto {
    type: string
    sql: CONCAT(CAST(${cd_sku} AS STRING), ' - ', ${TABLE}.dsc_cuf) ;;
    label: "Producto (CUF - Descripcion)"
  }

  # claves de join hacia la jerarquia (ocultas; se usan en el explore)
  dimension: id_marca        { hidden: yes type: number sql: ${TABLE}.id_marca ;; }
  dimension: id_categoria    { hidden: yes type: number sql: ${TABLE}.id_categoria ;; }
  dimension: id_subcategoria { hidden: yes type: number sql: ${TABLE}.id_subcategoria ;; }
  dimension: id_departamento { hidden: yes type: number sql: ${TABLE}.id_departamento ;; }

  # GAP Marca Propia: id_marcapropia NO es un flag (es un id de marca; 1666 = ~96%).
  # No reproduce el 8,10% del Power BI. Pendiente de definicion del negocio/ETL.
  dimension: id_marcapropia { hidden: yes type: number sql: ${TABLE}.id_marcapropia ;; }

  dimension: es_ecommerce {
    type: yesno
    sql: ${TABLE}.flg_esecommerce = '1' ;;
    label: "Ecommerce?"
  }
}
