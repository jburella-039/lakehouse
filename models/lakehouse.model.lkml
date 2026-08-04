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
# Se incluyen TODAS las vistas del proyecto con un unico glob recursivo (robusto,
# no depende de la carpeta): /**/*.view.lkml.
# =============================================================================
include: "/views/**/*.view.lkml"
include: "/views_FND/**/*.view.lkml"
include: "/views_MRT/**/*.view.lkml"
include: "/explores/*.explore.lkml"
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
