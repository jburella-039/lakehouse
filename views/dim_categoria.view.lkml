# dim_categoria - bss_comercial.dim_categoria. Clave: id_categoria.
# Fuente corregida por Dani (19/6): las trd_* NO se mapean a Looker; usar bss_comercial.
# El nombre legible (SIST. DIGESTIVO Y METABOLISMO, ...) esta en dsc_categoria.
view: dim_categoria {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_categoria` ;;

  dimension: id_categoria { primary_key: yes type: number sql: ${TABLE}.id_categoria ;; hidden: yes }
  dimension: categoria { type: string sql: ${TABLE}.dsc_categoria ;; label: "Categoria" }
  dimension: categoria_codigo { type: string sql: ${TABLE}.cd_categoria ;; hidden: yes }
  dimension: id_departamento { hidden: yes type: number sql: ${TABLE}.id_departamento ;; }
}
