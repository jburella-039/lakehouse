connection: "lakehouse-dev-483619"

# =============================================================================
# Estructura de vistas:
#   views/       -> vistas planas (una por entidad: dims + fct_remitos + fct_stock).
#                   Cada archivo tiene dimensiones y medidas juntas.
#   views_FND/   -> SOLO fct_ventas: capa fundacion (fnd_fct_ventas = mirror + PDT
#                   con hash de cabecera).
#   views_MRT/   -> SOLO fct_ventas: capa mart (mrt_fct_ventas extiende fnd_fct_ventas,
#                   expone campos y define las medidas). El explore fct_ventas usa
#                   from: mrt_fct_ventas.
# IMPORTANTE: todos los includes usan ** (glob recursivo). El patron de un solo *
#   (/views/*.view.lkml) NO matchea en esta instancia de Looker y deja las vistas
#   y explores huerfanos -> "view not found".
# =============================================================================
include: "/views/**/*.view.lkml"
include: "/views_FND/**/*.view.lkml"
include: "/views_MRT/**/*.view.lkml"
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
