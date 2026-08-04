# =============================================================================
# explore: fct_stock - Stock diario (snapshot por sucursal + articulo)
# "Ultimo dia" (es_ultimo_dia / *_ultimo_dia) = lo que resuelve StockDia.
# Misma estrella que fct_ventas reutilizando las dims STG.
# =============================================================================
explore: fct_stock {
  # from explicito (misma razon que fct_remitos): enlaza el explore con su vista base.
  from: fct_stock
  label: "Venta Integral - Stock"
  description: "Stock diario por sucursal y articulo. 'Ultimo dia' equivale a StockDia."

  join: dim_fecha {
    view_label: "Referencial - Fecha"
    type: left_outer
    relationship: many_to_one
    sql_on: DATE(${fct_stock.dia_raw}) = ${dim_fecha.fecha_date} ;;
  }

  # Producto (snowflake: Articulo -> Marca / Categoria / Subcategoria / Departamento).
  join: dim_articulo {
    view_label: "Comercial - Articulo"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_stock.cd_sku} = ${dim_articulo.cd_sku} ;;
  }
  join: dim_marca {
    view_label: "Comercial - Marca"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_marca} = ${dim_marca.id_marca} ;;
  }
  join: dim_categoria {
    view_label: "Comercial - Categoria"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_categoria} = ${dim_categoria.id_categoria} ;;
  }
  join: dim_subcategoria {
    view_label: "Comercial - Subcategoria"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_subcategoria} = ${dim_subcategoria.id_subcategoria} ;;
  }
  join: dim_departamento {
    view_label: "Comercial - Departamento"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_departamento} = ${dim_departamento.id_departamento} ;;
  }

  # Sucursal -> Formato / Region / Provincia.
  join: dim_sucursal {
    view_label: "Sucursales - Sucursal"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_stock.id_sucursal} = ${dim_sucursal.id_sucursal} ;;
  }
  join: dim_formato {
    view_label: "Sucursales - Formato"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_formato} = ${dim_formato.id_formato} ;;
  }
  join: dim_region {
    view_label: "Sucursales - Region"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_region} = ${dim_region.id_region} ;;
  }
  # Provincia real (via id_provincia de la sucursal). NO es dim_region (bricks/zonas).
  join: dim_provincia {
    view_label: "Sucursales - Provincia"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_provincia} = ${dim_provincia.id_provincia} ;;
  }
}
