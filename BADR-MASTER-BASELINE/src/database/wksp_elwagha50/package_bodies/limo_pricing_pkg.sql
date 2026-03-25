create or replace package body limo_pricing_pkg as

/* =====================================================
   Get Active KM Price
===================================================== */
    function get_km_price (
        p_car_type_id in varchar2,
        p_trip_date   in date default sysdate
    ) return number is
        l_price number;
    begin
        select
            k.price_per_km
        into l_price
        from
            limo_car_type_km_prices k
        where
                k.car_type_id = p_car_type_id
            and k.is_active = 'Y'
            and trunc(p_trip_date) between trunc(cast((k.effective_from at time zone 'UTC') as date)) and trunc(nvl(cast((k.effective_to
            at time zone 'UTC') as date),
                                                                                                                    trunc(p_trip_date
                                                                                                                    )))
        order by
            ( k.effective_from at time zone 'UTC' ) desc,
            k.price_id desc
        fetch first 1 row only;

        return l_price;
    exception
        when no_data_found then
            return null;
    end get_km_price;

/* =====================================================
   Get Active Trip / Daily Price
===================================================== */
    function get_trip_price (
        p_car_type_id in varchar2,
        p_trip_date   in date default sysdate
    ) return number is
        l_price number;
    begin
        select
            p.price_per_trip
        into l_price
        from
            limo_car_type_prices p
        where
                p.car_type_id = p_car_type_id
            and p_trip_date between nvl(p.start_date, p_trip_date) and nvl(p.end_date, p_trip_date)
        order by
            p.start_date desc
        fetch first 1 row only;

        return l_price;
    exception
        when no_data_found then
            return null;
    end get_trip_price;


/* =====================================================
   Get Per-Hour Price (Rate × Hours)
===================================================== */
    function get_hour_price (
        p_car_type_id in varchar2,
        p_hours       in number,
        p_trip_date   in date default sysdate
    ) return number is
        l_rate number;
    begin
        select
            h.base_price
        into l_rate
        from
            limo_car_type_hourly_rates h
        where
                h.car_type_id = p_car_type_id
            and h.is_active = 'Y'
            and h.hours = nvl(p_hours, 1)   -- ✅ مهم
            and p_trip_date between nvl(h.effective_from, p_trip_date) and nvl(h.effective_to, p_trip_date)
        order by
            nvl(h.effective_from, p_trip_date) desc,
            h.rate_id desc
        fetch first 1 row only;

        if l_rate is null then
            return null;
        end if;

  -- ✅ هنا نخليها ترجع سعر "p_hours" مباشرة
        return round(l_rate * nvl(p_hours, 1),
                     2);
    exception
        when no_data_found then
            return null;
    end get_hour_price;

/* =====================================================
   Set New KM Price
===================================================== */
    procedure set_km_price (
        p_car_type_id in varchar2,
        p_price_km    in number,
        p_currency    in varchar2,
        p_from_date   in date,
        p_notes       in varchar2 default null
    ) is
    begin

  /* Close old */
        update limo_car_type_km_prices
        set
            is_active = 'N',
            effective_to = p_from_date - 1
        where
                car_type_id = p_car_type_id
            and is_active = 'Y';

  /* Insert new */
        insert into limo_car_type_km_prices (
            price_id,
            car_type_id,
            price_per_km,
            currency,
            is_active,
            effective_from,
            notes,
            created,
            created_by
        ) values ( sys_guid(),
                   p_car_type_id,
                   p_price_km,
                   p_currency,
                   'Y',
                   p_from_date,
                   p_notes,
                   systimestamp,
                   nvl(
                       v('APP_USER_ID'),
                       user
                   ) );

        commit;
    end set_km_price;


/* =====================================================
   Set New Trip / Daily Price
===================================================== */
    procedure set_trip_price (
        p_car_type_id in varchar2,
        p_price       in number,
        p_currency    in varchar2,
        p_from_date   in date,
        p_to_date     in date default null,
        p_notes       in varchar2 default null
    ) is
    begin

  /* Close old */
        update limo_car_type_prices
        set
            end_date = p_from_date - 1
        where
                car_type_id = p_car_type_id
            and end_date is null;

  /* Insert new */
        insert into limo_car_type_prices (
            car_type_id,
            price_per_trip,
            currency,
            exchange_rate,
            is_special,
            start_date,
            end_date,
            notes,
            created,
            created_by
        ) values ( p_car_type_id,
                   p_price,
                   p_currency,
                   1,
                   'N',
                   p_from_date,
                   p_to_date,
                   p_notes,
                   systimestamp,
                   nvl(
                       v('APP_USER_ID'),
                       user
                   ) );

        commit;
    end set_trip_price;


/* =====================================================
   Set Per-Hour Price (Always 1 Hour)
===================================================== */
    procedure set_hour_price (
        p_car_type_id in varchar2,
        p_price_hour  in number,
        p_currency    in varchar2,
        p_from_date   in date,
        p_notes       in varchar2 default null
    ) is
    begin

  /* Close old */
        update limo_car_type_hourly_rates
        set
            is_active = 'N',
            effective_to = p_from_date - 1
        where
                car_type_id = p_car_type_id
            and is_active = 'Y';

  /* Insert new */
        insert into limo_car_type_hourly_rates (
            rate_id,
            car_type_id,
            hours,
            base_price,
            currency,
            is_active,
            effective_from,
            notes,
            created,
            created_by
        ) values ( sys_guid(),
                   p_car_type_id,
                   1, -- Always per 1 hour
                   p_price_hour,
                   p_currency,
                   'Y',
                   p_from_date,
                   p_notes,
                   systimestamp,
                   nvl(
                       v('APP_USER_ID'),
                       user
                   ) );

        commit;
    end set_hour_price;

end limo_pricing_pkg;
/


-- sqlcl_snapshot {"hash":"996ff6505e1abe139c257873f0335b0639dc49ed","type":"PACKAGE_BODY","name":"LIMO_PRICING_PKG","schemaName":"WKSP_ELWAGHA50","sxml":""}