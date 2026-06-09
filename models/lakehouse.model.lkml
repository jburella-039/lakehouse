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
  sql_trigger: SELECT MAX(DATE(fec_venta)) FROM `lakehouse-dev-483619.bss_oracle.fct_ventas` ;;
  max_cache_age: "24 hours"
}

persist_with: lakehouse_default_datagroup

explore: abtd_cmp_comprobantes {}

explore: bt_bon_bonificacionsistema {}

explore: bt_cmp_ordencomprabonificada {}

explore: bt_cmp_ordencomprabonificacion {}

explore: bt_cmp_pedido {}

explore: bt_adm_compfiscal {}

explore: abt_informesrecepcion {}

explore: bt_cmp_ordencompra {}

explore: bt_ped_drogexterna {}

explore: bt_stk_movimientos {}

explore: bt_stk_movimientos_fotopeps {}

explore: bt_stk_stockciclico {}

explore: bt_stk_stockcero {}

explore: bt_stk_movimientos_calc_peps_fraccionados {}

explore: bt_stk_stocktransito {}

explore: bt_stk_stock {}

explore: bt_vta_enviosemc {}

explore: bt_vta_granel {}

explore: bt_vta_farmacia {}

explore: bt_vta_ticketscufoferta {}

explore: bt_vta_tickets {}

explore: bt_vta_posvoucher {}

explore: bt_vta_ticketsformapago {}

explore: bt_vta_ticketsofertas {}

# =============================================================================
# explore: fct_ventas - Venta Integral (con joins snowflake)
# =============================================================================
explore: fct_ventas {
  label: "Venta Integral"
  description: "Ventas, tickets y unidades a nivel linea de comprobante."
  persist_with: venta_integral_datagroup

  # Evita escaneos de 1.8B filas: siempre filtra por dia contable.
  always_filter: {
    filters: [fct_ventas.dia_date: "1 months"]
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
    sql_on: ${dim_sucursal.id_formato} = ${dim_formato.cod_formato} ;;
  }
  join: dim_region {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_region} = ${dim_region.id_region} ;;
  }

  # Obra Social / Coseguro.
  join: dim_obrasocial {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_ventas.id_obrasocial} = ${dim_obrasocial.id_obrasocial} ;;
  }
}

# =============================================================================
# explore: fct_remitos - Venta Integral / Remitos (Farmacia, obra social)
# Fuente BT_VTA_FARMACIA. Misma estrella que fct_ventas reutilizando las dims.
# =============================================================================
explore: fct_remitos {
  label: "Venta Integral - Remitos"
  description: "Remitos de farmacia (obra social / dispensa): venta, unidades, margen."
  persist_with: venta_integral_datagroup

  always_filter: {
    filters: [fct_remitos.dia_date: "1 months"]
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
    sql_on: ${dim_sucursal.id_formato} = ${dim_formato.cod_formato} ;;
  }
  join: dim_region {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_region} = ${dim_region.id_region} ;;
  }

  # Obra Social (tipo dispensa vive en el hecho).
  join: dim_obrasocial {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_obrasocial} = ${dim_obrasocial.id_obrasocial} ;;
  }
}

explore: dim_vta_ticketsformapagoxcuf {}

