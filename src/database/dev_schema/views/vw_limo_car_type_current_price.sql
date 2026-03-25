create or replace force editionable view vw_limo_car_type_current_price (
    car_type_id,
    price_per_trip,
    currency,
    is_special,
    start_date,
    end_date
) as
    select
        car_type_id,
        price_per_trip,
        currency,
        is_special,
        start_date,
        end_date
    from
        (
            select
                p.car_type_id,
                p.price_per_trip,
                p.currency,
                p.is_special,
                p.start_date,
                p.end_date,
                row_number()
                over(partition by p.car_type_id
                     order by
                         p.is_special desc, p.start_date desc
                ) as rn
            from
                limo_car_type_prices p
            where
                (
        -- Active special price
                 p.is_special = 'Y'
                  and p.start_date <= current_timestamp at time zone 'Africa/Cairo'
                  and ( p.end_date is null
                        or p.end_date >= current_timestamp at time zone 'Africa/Cairo' ) )
                or (
        -- Fallback permanent price (only if no active special)
                 p.is_special = 'N'
                     and p.start_date <= current_timestamp at time zone 'Africa/Cairo'
                     and not exists (
                    select
                        1
                    from
                        limo_car_type_prices sp
                    where
                            sp.car_type_id = p.car_type_id
                        and sp.is_special = 'Y'
                        and sp.start_date <= current_timestamp at time zone 'Africa/Cairo'
                        and ( sp.end_date is null
                              or sp.end_date >= current_timestamp at time zone 'Africa/Cairo' )
                ) )
        )
    where
        rn = 1;


-- sqlcl_snapshot {"hash":"420e2b9d3bfa44e0d12309cecbb4034c6e05c89a","type":"VIEW","name":"VW_LIMO_CAR_TYPE_CURRENT_PRICE","schemaName":"DEV_SCHEMA","sxml":""}