-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464125360 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\vw_billable_order_items.sql
-- sqlcl_snapshot src/database/dev_schema/views/vw_billable_order_items.sql:null:97fc76ce7e516d617ddf16a3582bea0398b01008:create

create or replace force editionable view vw_billable_order_items (
    billing_group_id,
    customer_id,
    main_res_id,
    order_item_id,
    description,
    unit_price,
    quantity,
    total_price,
    currency_code
) as
    select
        m.billing_group_id,
        m.customer_id,

  /* Source references (for traceability only) */
        m.main_res_id,
        i.order_item_id,

  /* =========================
     Invoice description
     ========================= */
        case
    /* -------- LIMO -------- */
            when i.ref_table = 'SUBLEVEL_LIMO_RES'       then
                '🚗 '
                || nvl(ct.car_type_name, 'سيارة')
                || ' — '
                ||
                case
                        when l.trip_type = 'TRANSFER' then
                            'توصيلة'
                        when l.trip_type = 'DAILY'    then
                            'يومية'
                        else
                            'رحلة'
                end
                || ' ('
                || nvl(l.from_location, '-')
                || ' → '
                || nvl(l.to_location, '-')
                || ')'

    /* -------- FAST TRACK -------- */
            when i.ref_table = 'SUBLEVEL_FAST_TRACK_RES' then
                '✈️ '
                || sft.service_name
                || ' — '
                || ap.airport_name
                || ' (صالة '
                || ft.terminal_no
                || ')'
            else
                i.item_type
        end           as description,

  /* =========================
     Pricing
     ========================= */
        i.amount_orig as unit_price,
        1             as quantity,
        i.amount_orig as total_price,
        i.currency    as currency_code
    from
             main_reservations m
        join order_items                i on i.main_res_id = m.main_res_id
                              and nvl(i.is_cancelled, 'N') = 'N'

/* ---------- LIMO ---------- */
        left join sublevel_limo_res          l on i.ref_table = 'SUBLEVEL_LIMO_RES'
                                         and l.sub_res_id = i.ref_id
        left join limo_car_types             ct on ct.car_type_id = l.cat_item_id

/* ---------- FAST TRACK ---------- */
        left join sublevel_fast_track_res    ft on i.ref_table = 'SUBLEVEL_FAST_TRACK_RES'
                                                and ft.sub_res_id = i.ref_id
        left join fast_track_service_catalog sft on sft.service_id = ft.cat_item_id
        left join airports                   ap on ap.airport_id = ft.airport_id
    where
        m.billing_group_id is not null;

