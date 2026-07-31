connection: "lakehouse-dev-483619"

# =============================================================================
# Estructura de vistas:
#   views/   -> vistas planas (una por entidad: dims + fct_remitos + fct_stock).
#               Cada archivo tiene dimensiones y medidas juntas.
#   FND/MRT/ -> SOLO fct_ventas conserva el patron de dos capas:
#                 FND/ (fundacion: mirror + PDT con hash de cabecera)
#                 MRT/ (mart: extiende FND, expone campos y define las medidas).
#               FND entra de forma transitiva via el include de MRT/fct_ventas.
# =============================================================================
include: "/views/*.view.lkml"
include: "/MRT/**/*.view.lkml"
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
