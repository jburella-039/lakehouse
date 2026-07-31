# dim_subcategoria - bss_comercial.dim_subcategoria. Clave: id_subcategoria.
# Fuente corregida por Dani (19/6): usar bss_comercial (no trd_*). Nombre en dsc_subcategoria.
view: dim_subcategoria {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_subcategoria` ;;

  dimension: id_subcategoria { primary_key: yes type: number sql: ${TABLE}.id_subcategoria ;; hidden: yes }
  dimension: subcategoria { type: string sql: ${TABLE}.dsc_subcategoria ;; label: "Subcategoria" }
  dimension: id_categoria { hidden: yes type: number sql: ${TABLE}.id_categoria ;; }
}
