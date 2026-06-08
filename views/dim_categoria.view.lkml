# dim_categoria — trd_comercial.categoria. Clave: IdCategoria.
view: dim_categoria {
  sql_table_name: `lakehouse-dev-483619.trd_comercial.categoria` ;;

  dimension: id_categoria { primary_key: yes type: number sql: ${TABLE}.IdCategoria ;; hidden: yes }
  dimension: categoria { type: string sql: ${TABLE}.Categoria ;; label: "Categoría" }
  dimension: id_departamento { hidden: yes type: number sql: ${TABLE}.IdDepartamento ;; }
}
