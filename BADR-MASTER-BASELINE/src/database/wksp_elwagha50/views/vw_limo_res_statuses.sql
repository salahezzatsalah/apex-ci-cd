create or replace force editionable view vw_limo_res_statuses (
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
        limo_res_statuses
    where
        is_active = 'Y';


-- sqlcl_snapshot {"hash":"9f49884770af3d10c09b7fa28b30607fe4f9cf45","type":"VIEW","name":"VW_LIMO_RES_STATUSES","schemaName":"WKSP_ELWAGHA50","sxml":""}