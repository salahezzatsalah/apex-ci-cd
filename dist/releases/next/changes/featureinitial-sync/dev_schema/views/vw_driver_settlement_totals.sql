-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464129404 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\vw_driver_settlement_totals.sql
-- sqlcl_snapshot src/database/dev_schema/views/vw_driver_settlement_totals.sql:null:acfd74b9527bd139ca6635f6a7cebb69c8448621:create

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

