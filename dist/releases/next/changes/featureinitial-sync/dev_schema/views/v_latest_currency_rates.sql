-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464123857 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\v_latest_currency_rates.sql
-- sqlcl_snapshot src/database/dev_schema/views/v_latest_currency_rates.sql:null:049401f120a7170cee77d6f580d416657f50900e:create

create or replace force editionable view v_latest_currency_rates (
    currency_code,
    currency_name_ar,
    currency_name_en,
    symbol,
    exchange_rate,
    rate_date
) as
    select
        c.currency_code,
        c.currency_name_ar,
        c.currency_name_en,
        c.symbol,
        (
            select
                r.exchange_rate
            from
                currency_rates r
            where
                    r.currency_code = c.currency_code
                and r.rate_date = (
                    select
                        max(r2.rate_date)
                    from
                        currency_rates r2
                    where
                        r2.currency_code = c.currency_code
                )
            fetch first 1 rows only
        ) as exchange_rate,
        (
            select
                r.rate_date
            from
                currency_rates r
            where
                    r.currency_code = c.currency_code
                and r.rate_date = (
                    select
                        max(r2.rate_date)
                    from
                        currency_rates r2
                    where
                        r2.currency_code = c.currency_code
                )
            fetch first 1 rows only
        ) as rate_date
    from
        currencies c;

