connection: "lakehouse-dev-483619"

# =============================================================================
# Sistema multicapa Looker (Corebi):
#   views_raw/  -> capa CRUDA (mirror del origen BigQuery, fields_hidden_by_default)
#   views_trd/  -> capa TRD   (transformada/semantica: metricas expuestas al usuario)
#   explores/   -> logica de JOINs (consume solo vistas TRD)
#
# El modelo incluye SOLO la capa TRD y los explores: garantiza que los Explores se
# armen unicamente con vistas expuestas. Las vistas RAW entran de forma transitiva
# via el include de cada vista TRD (include: "/views_raw/raw_x.view.lkml").
# =============================================================================
include: "/views_trd/*.view.lkml"
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
