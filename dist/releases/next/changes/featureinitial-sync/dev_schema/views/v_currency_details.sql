-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464123390 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\v_currency_details.sql
-- sqlcl_snapshot src/database/dev_schema/views/v_currency_details.sql:null:ed7bc25feef385b84ef3c87f35ccc2b94e1a9b61:create

create or replace force editionable view v_currency_details (
    currency_code,
    currency_name_ar,
    currency_name_en,
    symbol,
    status,
    is_default_yn,
    created,
    created_by,
    exchange_rate_text,
    exchange_rate_value,
    updated,
    updated_by
) as
    select
        c.currency_code,
        c.currency_name_ar,
        c.currency_name_en,
        c.symbol,
        c.status,

    -- Is Default
        case
            when exists (
                select
                    1
                from
                    default_currency dc
                where
                    dc.currency_code = c.currency_code
            ) then
                'Y'
            else
                'N'
        end as is_default_yn,
        c.created,
        c.created_by,

    -- Exchange Rate as string (formatted or fallback message)
        case
            when c.currency_code = 'EGP' then
                'ج.م 1.00'
            else
                nvl((
                    select
                        'ج.م ' || to_char(exchange_rate, 'FM9999990.00')
                    from
                        (
            -- Priority 1: Latest active (<= today)
                            select
                                r.exchange_rate,
                                r.rate_date,
                                1 as priority
                            from
                                currency_rates r
                            where
                                    r.currency_code = c.currency_code
                                and r.rate_date <= sysdate
                            union all

            -- Priority 2: Nearest upcoming (> today), backup only
                            select
                                r.exchange_rate,
                                r.rate_date,
                                2 as priority
                            from
                                currency_rates r
                            where
                                    r.currency_code = c.currency_code
                                and r.rate_date > sysdate
                        )
                    order by
                        priority asc,
                        rate_date desc
                    fetch first 1 rows only
                ),
                    'لم يتم تسجيل سعر الصرف')
        end as exchange_rate_text,

    -- Exchange Rate as number
        (
            select
                r.exchange_rate
            from
                currency_rates r
            where
                    r.currency_code = c.currency_code
                and r.rate_date <= sysdate
            order by
                r.rate_date desc
            fetch first 1 rows only
        )   as exchange_rate_value,

    -- Last update timestamp fallback
        (
            select
                nvl(r.updated, r.created)
            from
                currency_rates r
            where
                    r.currency_code = c.currency_code
                and r.rate_date = (
                    select
                        max(rr.rate_date)
                    from
                        currency_rates rr
                    where
                        rr.currency_code = c.currency_code
                )
            fetch first 1 rows only
        )   as updated,

    -- Last updated_by fallback
        (
            select
                nvl(r.updated_by, r.created_by)
            from
                currency_rates r
            where
                    r.currency_code = c.currency_code
                and r.rate_date = (
                    select
                        max(rr.rate_date)
                    from
                        currency_rates rr
                    where
                        rr.currency_code = c.currency_code
                )
            fetch first 1 rows only
        )   as updated_by
    from
        currencies c;

