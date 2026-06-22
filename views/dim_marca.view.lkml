# dim_marca - bss_comercial.dim_marca. Clave: id_marca.
# Fuente corregida por Dani (19/6): usar bss_comercial (no trd_*).
# OJO: la columna del nombre es `dcs_marca` (asi viene en origen, con "dcs", no "dsc").
view: dim_marca {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_marca` ;;

  dimension: id_marca { primary_key: yes type: number sql: ${TABLE}.id_marca ;; hidden: yes }
  dimension: marca { type: string sql: ${TABLE}.dcs_marca ;; label: "Marca" }
  dimension: marca_codigo { type: string sql: ${TABLE}.cd_marca ;; hidden: yes }

  dimension: es_laboratorio { type: yesno sql: ${TABLE}.flg_eslaboratorio ;; label: "Es Laboratorio?" }
}
