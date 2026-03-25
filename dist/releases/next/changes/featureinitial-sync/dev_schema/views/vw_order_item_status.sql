-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464136950 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\vw_order_item_status.sql
-- sqlcl_snapshot src/database/dev_schema/views/vw_order_item_status.sql:null:3a3e94292a8999159ea876f205e6ff316e9ad9b0:create

create or replace force editionable view vw_order_item_status (
    order_item_id,
    main_res_id,
    ref_table,
    ref_id,
    status_code,
    status_label_ar,
    status_badge_class,
    status_order
) as
    select
        i.order_item_id,
        i.main_res_id,
        i.ref_table,
        i.ref_id,

    /* ---------- Unified Status Code ---------- */
        case
            when i.ref_table = 'SUBLEVEL_LIMO_RES'       then
                l.status_code
            when i.ref_table = 'SUBLEVEL_FAST_TRACK_RES' then
                f.status_code
        end as status_code,

    /* ---------- Arabic Label ---------- */
        case
            when i.ref_table = 'SUBLEVEL_LIMO_RES'       then
                ls.status_label_ar
            when i.ref_table = 'SUBLEVEL_FAST_TRACK_RES' then
                fs.status_label_ar
        end as status_label_ar,

    /* ---------- Badge Class ---------- */
        case
            when i.ref_table = 'SUBLEVEL_LIMO_RES'       then
                ls.status_badge_class
            when i.ref_table = 'SUBLEVEL_FAST_TRACK_RES' then
                fs.status_badge_class
        end as status_badge_class,

    /* ---------- Ordering ---------- */
        case
            when i.ref_table = 'SUBLEVEL_LIMO_RES'       then
                ls.status_order
            when i.ref_table = 'SUBLEVEL_FAST_TRACK_RES' then
                fs.status_order
        end as status_order
    from
        order_items                i

/* ===== LIMO ===== */
        left join sublevel_limo_res          l on i.ref_table = 'SUBLEVEL_LIMO_RES'
                                         and l.sub_res_id = i.ref_id
        left join vw_limo_res_statuses       ls on ls.status_code = l.status_code

/* ===== FAST TRACK ===== */
        left join sublevel_fast_track_res    f on i.ref_table = 'SUBLEVEL_FAST_TRACK_RES'
                                               and f.sub_res_id = i.ref_id
        left join vw_fast_track_res_statuses fs on fs.status_code = f.status_code;

