# dim_subcategoria — trd_comercial.subcategoria. Clave: IdSubcategoria.
view: dim_subcategoria {
  sql_table_name: `lakehouse-dev-483619.trd_comercial.subcategoria` ;;

  dimension: id_subcategoria { primary_key: yes type: number sql: ${TABLE}.IdSubcategoria ;; hidden: yes }
  dimension: subcategoria { type: string sql: ${TABLE}.Subcategoria ;; label: "Subcategoría" }
}
