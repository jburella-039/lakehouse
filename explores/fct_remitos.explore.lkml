# =============================================================================
# explore: fct_remitos - Venta Integral / Remitos (Farmacia, obra social)
# Misma estrella que fct_ventas reutilizando las dims STG. fec_dia es DATE.
# =============================================================================
explore: fct_remitos {
  # En esta instancia el explore en archivo separado necesita from explicito para
  # enlazar con su vista base (aunque el nombre coincida con la vista fct_remitos).
  from: fct_remitos
  label: "Venta Integral - Remitos"
  description: "Remitos de farmacia (obra social / dispensa): venta, unidades, margen."
  persist_with: venta_integral_datagroup

  # Calendario: misma fuente unica de Fecha/Año. fec_dia ya es DATE -> comparacion
  # directa contra fecha_date (sin envolver en DATE()).
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

  # Producto (nombre) via CUF; jerarquia via los HIS ids del hecho.
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

  # Sucursal -> Formato / Region / Provincia.
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
  # Provincia real (via id_provincia de la sucursal). NO es dim_region (bricks/zonas).
  join: dim_provincia {
    view_label: "Sucursales - Provincia"
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_sucursal.id_provincia} = ${dim_provincia.id_provincia} ;;
  }

  # Obra Social (tipo dispensa vive en el hecho).
  join: dim_obrasocial {
    view_label: "Salud - Obra Social"
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_remitos.id_obrasocial} = ${dim_obrasocial.id_obrasocial} ;;
  }
}
