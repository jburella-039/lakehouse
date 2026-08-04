connection: "lakehouse-dev-483619"

# =============================================================================
# Estructura de vistas (todo plano en views/):
#   - Una vista por entidad (dims + fct_remitos + fct_stock), dims y medidas juntas.
#   - fct_ventas mantiene dos capas (base fnd_fct_ventas + fct_ventas con medidas),
#     ambas en views/ (fct_ventas extends fnd_fct_ventas). El explore fct_ventas
#     usa la vista fct_ventas directamente (mismo nombre, sin from).
# Include unico anclado a la carpeta (patron probado): /views/**/*.view.lkml.
# =============================================================================
include: "/views/**/*.view.lkml"
include: "/explores/**/*.explore.lkml"
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
