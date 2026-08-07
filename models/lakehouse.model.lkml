connection: "lakehouse-dev-483619"

# =============================================================================
# Estructura de vistas (TODAS las entidades en dos capas BAS/ANL):
#   views_BAS/   -> capa BASE cruda: bas_<entidad> = espejo 1:1 del origen BigQuery
#                   con fields_hidden_by_default: yes (sin labels ni calculados).
#   views_ANL/   -> capa ANALISIS: anl_<entidad> extiende bas_<entidad>, expone lo
#                   curado con hidden: no + labels, calculados, PDT y medidas.
#   views/       -> solo queda fct_ventas_pktest (vista de prueba, no productiva).
#   Subcarpetas por dataset: bas_/anl_ + bss_comercial | bss_referencial |
#   bss_sucursales | bss_salud.
#
# Los explores (fct_ventas / fct_remitos / fct_stock) usan la capa ANL via
# `from: anl_<fct>`; cada join usa `from: anl_<dim>` (el nombre del join y las refs
# NO cambian, asi el dashboard sigue igual).
#
# Los explores viven INLINE en este model (no en /explores/*.explore.lkml). Es la
# topologia que valida en esta instancia: con los explores en archivos separados,
# las vistas no se resolvian y todo daba "could not find view".
# =============================================================================
include: "/views/**/*.view.lkml"
include: "/views_BAS/**/*.view.lkml"
include: "/views_ANL/**/*.view.lkml"
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
# explore: fct_ventas - Venta Integral (estrella snowflake sobre la capa ANL)
# Vista base anl_fct_ventas (capa ANALISIS: medidas + labels + PDT; extiende la
# capa BASE cruda bas_fct_ventas). El explore se llama fct_ventas (el dashboard
# referencia fct_ventas.*).
# =============================================================================
explore: fct_ventas {
  from: anl_fct_ventas
  label: "Venta Integral - Ventas"
  description: "Ventas, tickets y unidades a nivel linea de comprobante."
  persist_with: venta_integral_datagroup

  join: dim_fecha {
    from: anl_dim_fecha
    type: left_outer
    relationship: many_to_one
    sql_on: DATE(${fct_ventas.fec_dia_raw}) = ${dim_fecha.fecha_date} ;;
  }

  join: dim_tipocomprobante {
    from: anl_dim_tipocomprobante
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_tipocomprobante} = ${dim_tipocomprobante.id_tipocomprobante} ;;
  }

  join: dim_articulo {
    from: anl_dim_articulo
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.cd_sku} = ${dim_articulo.cd_sku} ;;
  }
  join: dim_marca {
    from: anl_dim_marca
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_marca} = ${dim_marca.id_marca} ;;
  }
  join: dim_categoria {
    from: anl_dim_categoria
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_categoria} = ${dim_categoria.id_categoria} ;;
  }
  join: dim_subcategoria {
    from: anl_dim_subcategoria
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_subcategoria} = ${dim_subcategoria.id_subcategoria} ;;
  }
  join: dim_departamento {
    from: anl_dim_departamento
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_departamento} = ${dim_departamento.id_departamento} ;;
  }

  join: dim_sucursal {
    from: anl_dim_sucursal
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_sucursal} = ${dim_sucursal.id_sucursal} ;;
  }
  join: dim_formato {
    from: anl_dim_formato
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_formato} = ${dim_formato.id_formato} ;;
  }
  join: dim_region {
    from: anl_dim_region
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_region} = ${dim_region.id_region} ;;
  }
  join: dim_provincia {
    from: anl_dim_provincia
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_provincia} = ${dim_provincia.id_provincia} ;;
  }

  join: dim_obrasocial {
    from: anl_dim_obrasocial
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_obrasocial} = ${dim_obrasocial.id_obrasocial} ;;
  }

  join: dim_origenventa {
    from: anl_dim_origenventa
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_origenventa} = ${dim_origenventa.id_origenventa} ;;
  }
}


# =============================================================================
# explore: fct_ventas_pktest - PRUEBA PK (NO productivo)
# Compara la PK nativa id_venta (BigQuery/Alex) contra el hash actual sobre la
# misma metrica de Tickets. Solo se une dim_tipocomprobante (para es_venta /
# resta_stock). Ver dashboards/pk_test.dashboard.lookml.
# =============================================================================
explore: fct_ventas_pktest {
  label: "PRUEBA - PK Ventas (id_venta vs hash)"
  description: "Validacion: id_venta nativo de BigQuery vs hash calculado en Looker."
  hidden: yes

  join: dim_tipocomprobante {
    from: anl_dim_tipocomprobante
    view_label: "Comercial - Tipo Comprobante"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas_pktest.id_tipocomprobante} = ${dim_tipocomprobante.id_tipocomprobante} ;;
  }
}


# =============================================================================
# explore: fct_remitos - Venta Integral / Remitos (Farmacia, obra social)
# Misma estrella que fct_ventas reutilizando las dims. fec_dia es DATE.
# =============================================================================
explore: fct_remitos {
  from: anl_fct_remitos
  label: "Venta Integral - Remitos"
  description: "Remitos de farmacia (obra social / dispensa): venta, unidades, margen."
  persist_with: venta_integral_datagroup

  join: dim_fecha {
    from: anl_dim_fecha
    view_label: "Referencial - Fecha"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.fec_dia_raw} = ${dim_fecha.fecha_date} ;;
  }

  join: dim_tipocomprobante {
    from: anl_dim_tipocomprobante
    view_label: "Comercial - Tipo Comprobante"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_tipocomprobante} = ${dim_tipocomprobante.id_tipocomprobante} ;;
  }

  join: dim_articulo {
    from: anl_dim_articulo
    view_label: "Comercial - Articulo"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.cd_sku} = ${dim_articulo.cd_sku} ;;
  }
  join: dim_marca {
    from: anl_dim_marca
    view_label: "Comercial - Marca"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_marca} = ${dim_marca.id_marca} ;;
  }
  join: dim_categoria {
    from: anl_dim_categoria
    view_label: "Comercial - Categoria"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_categoria} = ${dim_categoria.id_categoria} ;;
  }
  join: dim_subcategoria {
    from: anl_dim_subcategoria
    view_label: "Comercial - Subcategoria"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_subcategoria} = ${dim_subcategoria.id_subcategoria} ;;
  }
  join: dim_departamento {
    from: anl_dim_departamento
    view_label: "Comercial - Departamento"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_departamento} = ${dim_departamento.id_departamento} ;;
  }

  join: dim_sucursal {
    from: anl_dim_sucursal
    view_label: "Sucursales - Sucursal"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_sucursal} = ${dim_sucursal.id_sucursal} ;;
  }
  join: dim_formato {
    from: anl_dim_formato
    view_label: "Sucursales - Formato"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_formato} = ${dim_formato.id_formato} ;;
  }
  join: dim_region {
    from: anl_dim_region
    view_label: "Sucursales - Region"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_region} = ${dim_region.id_region} ;;
  }
  join: dim_provincia {
    from: anl_dim_provincia
    view_label: "Sucursales - Provincia"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_provincia} = ${dim_provincia.id_provincia} ;;
  }

  join: dim_obrasocial {
    from: anl_dim_obrasocial
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
    from: anl_dim_fecha
    view_label: "Referencial - Fecha"
    type: left_outer
    relationship: many_to_one
    sql_on: DATE(${fct_stock.dia_raw}) = ${dim_fecha.fecha_date} ;;
  }

  join: dim_articulo {
    from: anl_dim_articulo
    view_label: "Comercial - Articulo"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_stock.cd_sku} = ${dim_articulo.cd_sku} ;;
  }
  join: dim_marca {
    from: anl_dim_marca
    view_label: "Comercial - Marca"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_marca} = ${dim_marca.id_marca} ;;
  }
  join: dim_categoria {
    from: anl_dim_categoria
    view_label: "Comercial - Categoria"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_categoria} = ${dim_categoria.id_categoria} ;;
  }
  join: dim_subcategoria {
    from: anl_dim_subcategoria
    view_label: "Comercial - Subcategoria"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_subcategoria} = ${dim_subcategoria.id_subcategoria} ;;
  }
  join: dim_departamento {
    from: anl_dim_departamento
    view_label: "Comercial - Departamento"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_articulo.id_departamento} = ${dim_departamento.id_departamento} ;;
  }

  join: dim_sucursal {
    from: anl_dim_sucursal
    view_label: "Sucursales - Sucursal"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_stock.id_sucursal} = ${dim_sucursal.id_sucursal} ;;
  }
  join: dim_formato {
    from: anl_dim_formato
    view_label: "Sucursales - Formato"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_formato} = ${dim_formato.id_formato} ;;
  }
  join: dim_region {
    from: anl_dim_region
    view_label: "Sucursales - Region"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_region} = ${dim_region.id_region} ;;
  }
  join: dim_provincia {
    from: anl_dim_provincia
    view_label: "Sucursales - Provincia"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_provincia} = ${dim_provincia.id_provincia} ;;
  }
}
