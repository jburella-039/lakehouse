# =============================================================================
# TRD view: dim_departamento  (capa semantica). Extiende raw_dim_departamento.
# =============================================================================

include: "/views_raw/raw_dim_departamento.view.lkml"

view: dim_departamento {
  extends: [raw_dim_departamento]
  label: "Comercial - Departamento"

  dimension: departamento { hidden: no }
}
