connection: "lakehouse-dev-483619"

# =============================================================================
# Estructura de vistas:
#   views/       -> vistas planas (una por entidad: dims + fct_remitos + fct_stock).
#   views_FND/   -> SOLO fct_ventas: capa fundacion (fnd_fct_ventas = mirror + PDT
#                   con hash de cabecera).
#   views_MRT/   -> SOLO fct_ventas: capa mart (mrt_fct_ventas extiende fnd_fct_ventas,
#                   expone campos y define las medidas).
#
# Los explores viven INLINE en este model (no en /explores/*.explore.lkml). Es la
# topologia que valida en esta instancia: con los explores en archivos separados,
# las vistas no se resolvian y todo daba "could not find view".
# =============================================================================
include: "/views/**/*.view.lkml"
include: "/views_FND/**/*.view.lkml"
include: "/views_MRT/**/*.view.lkml"
# include LookML dashboards (Venta Integral)
include: "/dashboards/**/*.dashboard.lookml"

datagroup: lakehouse_default_datagroup {
  max_cache_age: "1 hour"
}

# Cache diario para Venta Integral aprovechando el particionado por fecha de la fct.
datagroup: venta_integral_datagroup {
  sql_trigger: SELECT MAX(DATE(fec_venta)) FROM `lakehouse-dev-483619.bss_comercial.vw_fct_ventas` ;;
  max_cache_age: "24 hours"
}

persist_with: lakehouse_default_datagroup


# =============================================================================
# explore: fct_ventas - Venta Integral (estrella snowflake sobre la capa MRT)
# Vista base mrt_fct_ventas (capa MRT con medidas + PDT/hash via fnd_fct_ventas).
# El explore se llama fct_ventas (el dashboard referencia fct_ventas.*).
# =============================================================================
explore: fct_ventas {
  from: mrt_fct_ventas
  label: "Venta Integral - Ventas"
  description: "Ventas, tickets y unidades a nivel linea de comprobante."
  persist_with: venta_integral_datagroup

  join: dim_fecha {
    view_label: "Referencial - Fecha"
    type: left_outer
    relationship: many_to_one
    sql_on: DATE(${fct_ventas.dia_raw}) = ${dim_fecha.fecha_date} ;;
  }

  join: dim_tipocomprobante {
    view_label: "Comercial - Tipo Comprobante"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_tipocomprobante} = ${dim_tipocomprobante.id_tipocomprobante} ;;
  }

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
  join: dim_provincia {
    view_label: "Sucursales - Provincia"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_provincia} = ${dim_provincia.id_provincia} ;;
  }

  join: dim_obrasocial {
    view_label: "Salud - Obra Social"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_obrasocial} = ${dim_obrasocial.id_obrasocial} ;;
  }

  join: dim_origenventa {
    view_label: "Comercial - Origen de Venta"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_origenventa} = ${dim_origenventa.id_origenventa} ;;
  }
}


# =============================================================================
# explore: fct_remitos - Venta Integral / Remitos (Farmacia, obra social)
# Misma estrella que fct_ventas reutilizando las dims. fec_dia es DATE.
# =============================================================================
explore: fct_remitos {
  label: "Venta Integral - Remitos"
  description: "Remitos de farmacia (obra social / dispensa): venta, unidades, margen."
  persist_with: venta_integral_datagroup

  join: dim_fecha {
    view_label: "Referencial - Fecha"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.dia_raw} = ${dim_fecha.fecha_date} ;;
  }

  join: dim_tipocomprobante {
    view_label: "Comercial - Tipo Comprobante"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_tipocomprobante} = ${dim_tipocomprobante.id_tipocomprobante} ;;
  }

  join: dim_articulo {
    view_label: "Comercial - Articulo"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.cd_sku} = ${dim_articulo.cd_sku} ;;
  }
  join: dim_marca {
    view_label: "Comercial - Marca"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_marca} = ${dim_marca.id_marca} ;;
  }
  join: dim_categoria {
    view_label: "Comercial - Categoria"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_categoria} = ${dim_categoria.id_categoria} ;;
  }
  join: dim_subcategoria {
    view_label: "Comercial - Subcategoria"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_subcategoria} = ${dim_subcategoria.id_subcategoria} ;;
  }
  join: dim_departamento {
    view_label: "Comercial - Departamento"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_departamento} = ${dim_departamento.id_departamento} ;;
  }

  join: dim_sucursal {
    view_label: "Sucursales - Sucursal"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_sucursal} = ${dim_sucursal.id_sucursal} ;;
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
  join: dim_provincia {
    view_label: "Sucursales - Provincia"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_provincia} = ${dim_provincia.id_provincia} ;;
  }

  join: dim_obrasocial {
    view_label: "Salud - Obra Social"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_obrasocial} = ${dim_obrasocial.id_obrasocial} ;;
  }
}


# =============================================================================
# explore: fct_stock - Stock diario (snapshot por sucursal + articulo)
# "Ultimo dia" (es_ultimo_dia / *_ultimo_dia) = lo que resuelve StockDia.
# =============================================================================
explore: fct_stock {
  label: "Venta Integral - Stock"
  description: "Stock diario por sucursal y articulo. 'Ultimo dia' equivale a StockDia."

  join: dim_fecha {
    view_label: "Referencial - Fecha"
    type: left_outer
    relationship: many_to_one
    sql_on: DATE(${fct_stock.dia_raw}) = ${dim_fecha.fecha_date} ;;
  }

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
  join: dim_provincia {
    view_label: "Sucursales - Provincia"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_provincia} = ${dim_provincia.id_provincia} ;;
  }
}
