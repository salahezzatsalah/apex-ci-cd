create or replace force editionable view vw_client_metrics (
    client_id,
    total_reservations,
    lifetime_value,
    last_activity
) as
    select
        c.client_id,
        count(r.main_res_id) as total_reservations,
        sum(r.total_amount)  as lifetime_value,
        max(e.event_date)    as last_activity
    from
        clients           c
        left join main_reservations r on r.customer_id = c.client_id
        left join client_events     e on e.client_id = c.client_id
    group by
        c.client_id;


-- sqlcl_snapshot {"hash":"fdb4e7aa161b6b9a02095ab3cfcc55dcc0b3344a","type":"VIEW","name":"VW_CLIENT_METRICS","schemaName":"WKSP_ELWAGHA50","sxml":""}