# dim_marca - bss_comercial.dim_marca. Clave: id_marca.
# Fuente corregida por Dani (19/6): usar bss_comercial (no trd_*).
# La columna del nombre es `dsc_marca` (verificado en INFORMATION_SCHEMA 2026-06-24;
# antes decia "dcs_marca" por error y rompia el grafico Top Marcas / filtro Marca).
view: dim_marca {
  sql_table_name: `lakehouse-dev-483619.bss_comercial.dim_marca` ;;

  dimension: id_marca { primary_key: yes type: number sql: ${TABLE}.id_marca ;; hidden: yes }
  dimension: marca { type: string sql: ${TABLE}.dsc_marca ;; label: "Marca" }
  dimension: marca_codigo { type: string sql: ${TABLE}.cd_marca ;; hidden: yes }

  dimension: es_laboratorio { type: yesno sql: ${TABLE}.flg_eslaboratorio ;; label: "Es Laboratorio?" }
}
