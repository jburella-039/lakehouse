# dim_sucursal - bss_sucursales.dim_sucursal. Clave: id_sucursal.
view: dim_sucursal {
  sql_table_name: `lakehouse-dev-483619.bss_sucursales.dim_sucursal` ;;

  dimension: id_sucursal { primary_key: yes type: number sql: ${TABLE}.id_sucursal ;; label: "Sucursal (ID)" }
  dimension: cd_sucursal { type: number sql: ${TABLE}.cd_sucursal ;; label: "Sucursal (codigo)" }
  dimension: sucursal { type: string sql: ${TABLE}.dsc_sucursal ;; label: "Sucursal" }
  dimension: sucursal_corta { type: string sql: ${TABLE}.dsc_sucursalcorta ;; label: "Sucursal (corta)" }

  # Codigo + descripcion: "<cd_sucursal> - <descripcion>". Para el filtro Sucursal
  # del tablero. Usa cd_sucursal (codigo de negocio).
  dimension: dsc_codsucursal {
    type: string
    sql: CONCAT(CAST(${cd_sucursal} AS STRING), ' - ', ${TABLE}.dsc_sucursal) ;;
    label: "Cod - Sucursal"
  }

  dimension: id_formato   { hidden: yes type: number sql: ${TABLE}.id_formato ;; }
  dimension: id_region    { hidden: yes type: number sql: ${TABLE}.id_region ;; }
  dimension: id_provincia { hidden: yes type: number sql: ${TABLE}.id_provincia ;; }
  dimension: es_capital { type: yesno sql: ${TABLE}.flg_escapital = 1 ;; label: "Es Capital?" }
}
