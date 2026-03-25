-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464136449 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\vw_limo_trip_accounting_json.sql
-- sqlcl_snapshot src/database/dev_schema/views/vw_limo_trip_accounting_json.sql:null:353ed99d2c673e4d1c6ceb13e8a7ffa311867709:create

create or replace force editionable view vw_limo_trip_accounting_json (
    trip_id,
    json_data
) as
    select
        trip_id,
        json_object(
                'driver' value driver_name,
                'currency' value trip_currency,
                'base_price' value base_price_currency,
                'base_price_egp' value base_price_egp,
                'added_services' value added_services_currency,
                        'added_services_egp' value added_services_egp,
                'expenses_egp' value trip_expenses_egp,
                'driver_trip_egp' value driver_share_from_trip_egp,
                'driver_services_egp' value driver_share_from_services_egp,
                'total_invoice' value total_invoice_currency,
                        'total_invoice_egp' value total_invoice_egp,
                'total_driver_payout' value total_driver_payout_egp,
                'office_net' value office_net_currency,
                'office_net_egp' value office_net_egp,
                'net_after_expenses' value revenue_after_expenses_egp,
                        'paid' value paid_amount_orig_curr,
                'paid_egp' value paid_amount_egp,
                'outstanding' value outstanding_amount_orig_curr,
                'outstanding_egp' value outstanding_amount_egp
            returning clob)
        as json_data
    from
        vw_limo_trip_accounting;

