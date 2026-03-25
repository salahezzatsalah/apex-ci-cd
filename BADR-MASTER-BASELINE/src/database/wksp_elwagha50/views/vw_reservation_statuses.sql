create or replace force editionable view vw_reservation_statuses (
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
        reservation_statuses
    where
        is_active = 'Y';


-- sqlcl_snapshot {"hash":"8dd856082ddee914f431341714b34ff715e0bd18","type":"VIEW","name":"VW_RESERVATION_STATUSES","schemaName":"WKSP_ELWAGHA50","sxml":""}