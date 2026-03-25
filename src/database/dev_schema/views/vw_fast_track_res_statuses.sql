create or replace force editionable view vw_fast_track_res_statuses (
    status_code,
    status_label_ar,
    status_label_en,
    status_badge_class,
    status_order
) as
    select
        status_code,
        status_label_ar,
        status_label_en,
        status_badge_class,
        status_order
    from
        fast_track_res_statuses
    where
        is_active = 'Y';


-- sqlcl_snapshot {"hash":"66ae2bd91087b41fb31777bdc0db196e516d1337","type":"VIEW","name":"VW_FAST_TRACK_RES_STATUSES","schemaName":"DEV_SCHEMA","sxml":""}