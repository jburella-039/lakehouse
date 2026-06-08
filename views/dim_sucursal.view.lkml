# dim_sucursal — bss_sucursales.dim_sucursal. Clave: id_sucursal.
view: dim_sucursal {
  sql_table_name: `lakehouse-dev-483619.bss_sucursales.dim_sucursal` ;;

  dimension: id_sucursal { primary_key: yes type: number sql: ${TABLE}.id_sucursal ;; label: "Sucursal (ID)" }
  dimension: sucursal { type: string sql: ${TABLE}.dsc_sucursal ;; label: "Sucursal" }
  dimension: sucursal_corta { type: string sql: ${TABLE}.dsc_sucursalcorta ;; label: "Sucursal (corta)" }

  dimension: id_formato { hidden: yes type: number sql: ${TABLE}.id_formato ;; }
  dimension: id_region  { hidden: yes type: number sql: ${TABLE}.id_region ;; }
  dimension: es_capital { type: yesno sql: ${TABLE}.flg_escapital = 1 ;; label: "¿Es Capital?" }
}
