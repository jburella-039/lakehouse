# dim_marca - trd_comercial.marca. Clave: IdMarca.
view: dim_marca {
  sql_table_name: `lakehouse-dev-483619.trd_comercial.marca` ;;

  dimension: id_marca { primary_key: yes type: number sql: ${TABLE}.IdMarca ;; hidden: yes }

  # OJO: la columna `Marca` trae un codigo (ej. "*7"); el nombre legible
  # (Elea, ROEMMERS, ...) esta en `Descripcion`.
  dimension: marca { type: string sql: ${TABLE}.Descripcion ;; label: "Marca" }
  dimension: marca_codigo { type: string sql: ${TABLE}.Marca ;; hidden: yes }

  dimension: es_laboratorio { type: yesno sql: ${TABLE}.EsLaboratorio ;; label: "Es Laboratorio?" }

  # GAP: EsMarcaPropia esta SIN POBLAR en trd_comercial.marca (0/4220 en true).
  # El "Marca Propia" del Power BI (8,10%) no es reproducible hasta que el ETL
  # popule este flag (o se cargue la lista de marcas propias). NO usar todavia.
  dimension: es_marca_propia { type: yesno sql: ${TABLE}.EsMarcaPropia ;; label: "Marca Propia? (sin poblar)" }
}
