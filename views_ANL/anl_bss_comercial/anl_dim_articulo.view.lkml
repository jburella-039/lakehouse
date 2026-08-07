include: "/views_BAS/bas_bss_comercial/bas_dim_articulo.view.lkml"

view: anl_dim_articulo {
  extends: [bas_dim_articulo]

  dimension: cd_sku { primary_key: yes  hidden: no  label: "SKU" }

  dimension: descripcion {
    hidden: no
    type: string
    sql: ${TABLE}.dsc_sku ;;
    label: "Descripcion"
  }

  dimension: producto {
    hidden: no
    type: string
    sql: CONCAT(CAST(${cd_sku} AS STRING), ' - ', ${TABLE}.dsc_sku) ;;
    label: "Producto (SKU - Descripcion)"
  }

  dimension: marca_propia {
    hidden: no
    type: string
    sql: CASE WHEN ${TABLE}.id_sector = 3 THEN 'Marca Propia' ELSE 'Resto' END ;;
    label: "Marca Propia"
  }

  dimension: es_ecommerce {
    hidden: no
    type: yesno
    sql: ${TABLE}.flg_esecommerce = '1' ;;
    label: "Ecommerce?"
  }
}
