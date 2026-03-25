create or replace force editionable view vw_driver_settlement_totals (
    driver_id,
    assignment_id,
    product_id,
    currency,
    settlement_type,
    total_amount,
    total_egp
) as
    select
        driver_id,
        assignment_id,
        product_id,
        currency,
        settlement_type,
        sum(amount)     as total_amount,
        sum(amount_egp) as total_egp
    from
        limo_driver_settlements
    group by
        driver_id,
        assignment_id,
        product_id,
        currency,
        settlement_type;


-- sqlcl_snapshot {"hash":"acfd74b9527bd139ca6635f6a7cebb69c8448621","type":"VIEW","name":"VW_DRIVER_SETTLEMENT_TOTALS","schemaName":"WKSP_ELWAGHA50","sxml":""}