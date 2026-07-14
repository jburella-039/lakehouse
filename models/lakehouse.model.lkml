connection: "lakehouse-dev-483619"

# include all the views
include: "/views/**/*.view.lkml"
# include LookML dashboards (Venta Integral)
include: "/dashboards/**/*.dashboard.lookml"

datagroup: lakehouse_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

# Cache diario para Venta Integral aprovechando el particionado por fecha de la fct.
datagroup: venta_integral_datagroup {
  sql_trigger: SELECT MAX(DATE(fec_venta)) FROM `lakehouse-dev-483619.bss_comercial.vw_fct_ventas` ;;
  max_cache_age: "24 hours"
}

persist_with: lakehouse_default_datagroup

# =============================================================================
# explore: fct_ventas - Venta Integral (con joins snowflake)
# =============================================================================
explore: fct_ventas {
  label: "Fact Ventas"
  description: "Ventas, tickets y unidades a nivel linea de comprobante."
  persist_with: venta_integral_datagroup

  # Calendario: fuente unica de Fecha/Año de los dashboards (DATE puro, sin
  # corrimiento por timezone). Join por la fecha contable del hecho. many_to_one
  # al mismo grano (1 fila de calendario por fecha) -> no infla las medidas.
  join: dim_fecha {
    type: left_outer
    relationship: many_to_one
    sql_on: DATE(${fct_ventas.dia_raw}) = ${dim_fecha.fecha_date} ;;
  }

  # Tipo de comprobante: trae flags ESVENTA / RESTASTOCK (filtran las medidas).
  join: dim_tipocomprobante {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_tipocomprobante} = ${dim_tipocomprobante.id_tipocomprobante} ;;
  }

  # Producto (snowflake: Articulo -> Marca / Categoria / Subcategoria / Departamento).
  join: dim_articulo {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.cd_sku} = ${dim_articulo.cd_sku} ;;
  }
  join: dim_marca {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_marca} = ${dim_marca.id_marca} ;;
  }
  join: dim_categoria {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_categoria} = ${dim_categoria.id_categoria} ;;
  }
  join: dim_subcategoria {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_subcategoria} = ${dim_subcategoria.id_subcategoria} ;;
  }
  join: dim_departamento {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_departamento} = ${dim_departamento.id_departamento} ;;
  }

  # Sucursal -> Formato (Bis) / Region.
  join: dim_sucursal {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_sucursal} = ${dim_sucursal.id_sucursal} ;;
  }
  join: dim_formato {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_formato} = ${dim_formato.id_formato} ;;
  }
  join: dim_region {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_region} = ${dim_region.id_region} ;;
  }
  # Provincia real (via id_provincia de la sucursal). NO es dim_region (bricks/zonas).
  join: dim_provincia {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_provincia} = ${dim_provincia.id_provincia} ;;
  }

  # Obra Social / Coseguro.
  join: dim_obrasocial {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_obrasocial} = ${dim_obrasocial.id_obrasocial} ;;
  }

  # Canal / Origen de Venta (PDV, Farmacity Online, MERCADOFULL, ...) + presencialidad.
  join: dim_origenventa {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_origenventa} = ${dim_origenventa.id_origenventa} ;;
  }
}

# =============================================================================
# explore: fct_remitos - Venta Integral / Remitos (Farmacia, obra social)
# Fuente BT_VTA_FARMACIA. Misma estrella que fct_ventas reutilizando las dims.
# =============================================================================
explore: fct_remitos {
  label: "Fact Remitos"
  description: "Remitos de farmacia (obra social / dispensa): venta, unidades, margen."
  persist_with: venta_integral_datagroup

  # Calendario: misma fuente unica de Fecha/Año (ver fct_ventas). Join por el dia
  # del remito (fec_dia). many_to_one al mismo grano -> no infla las medidas.
  # fec_dia en vw_fct_remitos ya es DATE, asi que se compara directo contra
  # fecha_date (sin envolver en DATE(), que no acepta un argumento DATE).
  join: dim_fecha {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.dia_raw} = ${dim_fecha.fecha_date} ;;
  }

  join: dim_tipocomprobante {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_tipocomprobante} = ${dim_tipocomprobante.id_tipocomprobante} ;;
  }

  # Producto (nombre) via CUF; jerarquia via los HIS ids del hecho.
  join: dim_articulo {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.cd_sku} = ${dim_articulo.cd_sku} ;;
  }
  join: dim_marca {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_marca} = ${dim_marca.id_marca} ;;
  }
  join: dim_categoria {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_categoria} = ${dim_categoria.id_categoria} ;;
  }
  join: dim_subcategoria {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_subcategoria} = ${dim_subcategoria.id_subcategoria} ;;
  }
  join: dim_departamento {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_departamento} = ${dim_departamento.id_departamento} ;;
  }

  # Sucursal -> Formato / Region.
  join: dim_sucursal {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_sucursal} = ${dim_sucursal.id_sucursal} ;;
  }
  join: dim_formato {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_formato} = ${dim_formato.id_formato} ;;
  }
  join: dim_region {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_region} = ${dim_region.id_region} ;;
  }
  # Provincia real (via id_provincia de la sucursal). NO es dim_region (bricks/zonas).
  join: dim_provincia {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_provincia} = ${dim_provincia.id_provincia} ;;
  }

  # Obra Social (tipo dispensa vive en el hecho).
  join: dim_obrasocial {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_obrasocial} = ${dim_obrasocial.id_obrasocial} ;;
  }
}

# =============================================================================
# explore: fct_stock - Stock diario (snapshot por sucursal + articulo)
# "Ultimo dia" (es_ultimo_dia / *_ultimo_dia) = lo que resuelve StockDia.
# Misma estrella que fct_ventas reutilizando las dims.
# =============================================================================
explore: fct_stock {
  label: "Fact Stock"
  description: "Stock diario por sucursal y articulo. 'Ultimo dia' equivale a StockDia."

  join: dim_fecha {
    type: left_outer
    relationship: many_to_one
    sql_on: DATE(${fct_stock.dia_raw}) = ${dim_fecha.fecha_date} ;;
  }

  # Producto (snowflake: Articulo -> Marca / Categoria / Subcategoria / Departamento).
  join: dim_articulo {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_stock.cd_sku} = ${dim_articulo.cd_sku} ;;
  }
  join: dim_marca {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_marca} = ${dim_marca.id_marca} ;;
  }
  join: dim_categoria {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_categoria} = ${dim_categoria.id_categoria} ;;
  }
  join: dim_subcategoria {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_subcategoria} = ${dim_subcategoria.id_subcategoria} ;;
  }
  join: dim_departamento {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_departamento} = ${dim_departamento.id_departamento} ;;
  }

  # Sucursal -> Formato / Region.
  join: dim_sucursal {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_stock.id_sucursal} = ${dim_sucursal.id_sucursal} ;;
  }
  join: dim_formato {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_formato} = ${dim_formato.id_formato} ;;
  }
  join: dim_region {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_region} = ${dim_region.id_region} ;;
  }
  # Provincia real (via id_provincia de la sucursal). NO es dim_region (bricks/zonas).
  join: dim_provincia {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_provincia} = ${dim_provincia.id_provincia} ;;
  }
}

