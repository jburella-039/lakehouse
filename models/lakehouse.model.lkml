connection: "lakehouse-dev-483619"

# include all the views
include: "/views/**/*.view.lkml"

datagroup: lakehouse_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
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

explore: fct_ventas {}

explore: dim_vta_ticketsformapagoxcuf {}

