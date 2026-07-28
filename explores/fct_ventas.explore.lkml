# =============================================================================
# explore: fct_ventas - Venta Integral (estrella snowflake sobre la capa STG)
# Los joins consumen SOLO vistas STG. view_label prefija el area (Comercial /
# Referencial / Sucursales / Salud) para el usuario que arma reportes.
# =============================================================================
explore: fct_ventas {
  label: "Venta Integral - Ventas"
  description: "Ventas, tickets y unidades a nivel linea de comprobante."
  persist_with: venta_integral_datagroup

  # Calendario: fuente unica de Fecha/Año (DATE puro). many_to_one al mismo grano.
  join: dim_fecha {
    view_label: "Referencial - Fecha"
    type: left_outer
    relationship: many_to_one
    sql_on: DATE(${fct_ventas.dia_raw}) = ${dim_fecha.fecha_date} ;;
  }

  # Tipo de comprobante: trae flags ESVENTA / RESTASTOCK (filtran las medidas).
  join: dim_tipocomprobante {
    view_label: "Comercial - Tipo Comprobante"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_tipocomprobante} = ${dim_tipocomprobante.id_tipocomprobante} ;;
  }

  # Producto (snowflake: Articulo -> Marca / Categoria / Subcategoria / Departamento).
  join: dim_articulo {
    view_label: "Comercial - Articulo"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.cd_sku} = ${dim_articulo.cd_sku} ;;
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

  # Sucursal -> Formato (Bis) / Region / Provincia.
  join: dim_sucursal {
    view_label: "Sucursales - Sucursal"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_sucursal} = ${dim_sucursal.id_sucursal} ;;
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

  # Obra Social / Coseguro.
  join: dim_obrasocial {
    view_label: "Salud - Obra Social"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_obrasocial} = ${dim_obrasocial.id_obrasocial} ;;
  }

  # Canal / Origen de Venta (PDV, Farmacity Online, MERCADOFULL, ...) + presencialidad.
  join: dim_origenventa {
    view_label: "Comercial - Origen de Venta"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_origenventa} = ${dim_origenventa.id_origenventa} ;;
  }
}
