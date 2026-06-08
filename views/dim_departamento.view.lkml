# dim_departamento — bss_comercial.dim_departamento. Clave: id_departamento.
view: dim_departamento {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_departamento` ;;

  dimension: id_departamento { primary_key: yes type: number sql: ${TABLE}.id_departamento ;; hidden: yes }
  dimension: departamento { type: string sql: ${TABLE}.dsc_departamento ;; label: "Departamento" }
}
