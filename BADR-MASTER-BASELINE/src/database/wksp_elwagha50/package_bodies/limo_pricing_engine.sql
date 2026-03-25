create or replace package body limo_pricing_engine as

    procedure build_results (
        p_session_id       in varchar2,
        p_service_type     in varchar2,
        p_from_loc         in varchar2,
        p_to_loc           in varchar2,
        p_airport_code     in varchar2,
        p_distance_km      in number,
        p_pickup_date_from in date default null,
        p_pickup_date_to   in date default null,
        p_hours            in number default null,
        p_pax              in number,
        p_bags             in number,
        p_trip_date        in date,
        p_is_return        in varchar2 default 'N',
        p_pickup_time      in varchar2 default null
    ) is

        v_price_per_km number;
        v_hour_1h      number;
        v_base_price   number; -- one-way total (AIRPORT/TRANSFER) OR daily_price (DAILY)
        v_final_price  number; -- final total (with return for AIRPORT)

        v_currency     varchar2(10);
        v_model        varchar2(30);
        v_is_return    varchar2(1) := upper(nvl(
            trim(p_is_return),
            'N'
        ));

    -- (اختياري) تجيب العملة من جدول الكيلو لو محتاجاها
        function get_km_currency (
            p_car_id varchar2,
            p_dt     date
        ) return varchar2 is
            l_curr varchar2(10);
        begin
            select
                k.currency
            into l_curr
            from
                limo_car_type_km_prices k
            where
                    k.car_type_id = p_car_id
                and k.is_active = 'Y'
                and trunc(p_dt) between trunc(cast((k.effective_from at time zone 'UTC') as date)) and trunc(nvl(cast((k.effective_to
                at time zone 'UTC') as date),
                                                                                                                 trunc(p_dt)))
            order by
                ( k.effective_from at time zone 'UTC' ) desc,
                k.price_id desc
            fetch first 1 row only;

            return l_curr;
        exception
            when no_data_found then
                return 'EGP';
        end;

    -- (اختياري) تجيب العملة من جدول الساعة لو محتاجاها
        function get_hour_currency (
            p_car_id varchar2,
            p_dt     date
        ) return varchar2 is
            l_curr varchar2(10);
        begin
            select
                h.currency
            into l_curr
            from
                limo_car_type_hourly_rates h
            where
                    h.car_type_id = p_car_id
                and h.is_active = 'Y'
                and h.hours = 1
                and trunc(p_dt) between trunc(cast((h.effective_from at time zone 'UTC') as date)) and trunc(nvl(cast((h.effective_to
                at time zone 'UTC') as date),
                                                                                                                 trunc(p_dt)))
            order by
                ( h.effective_from at time zone 'UTC' ) desc,
                h.rate_id desc
            fetch first 1 row only;

            return l_curr;
        exception
            when no_data_found then
                return 'EGP';
        end;

    begin
        delete from limo_search_runtime
        where
            session_id = p_session_id;

        for c in (
            select
                *
            from
                limo_car_types
            where
                    status = 'ACTIVE'
                and ( p_pax is null
                      or max_passengers >= p_pax )
                and ( p_bags is null
                      or max_luggage >= p_bags )
        ) loop
            v_price_per_km := null;
            v_hour_1h := null;
            v_base_price := null;
            v_final_price := null;
            v_currency := 'EGP';
            v_model := null;

      -- =========================================================
      -- AIRPORT / TRANSFER
      -- السعر = price_per_km * distance_km
      -- ولو AIRPORT و return=Y => *2
      -- =========================================================
            if upper(p_service_type) in ( 'AIRPORT', 'TRANSFER' ) then
                v_price_per_km := limo_pricing_pkg.get_km_price(
                    p_car_type_id => c.car_type_id,
                    p_trip_date   => p_trip_date
                );

                if v_price_per_km is null then
                    continue; -- مفيش تسعير => متظهرش
                end if;
                v_currency := get_km_currency(c.car_type_id, p_trip_date);
                v_base_price := v_price_per_km * nvl(p_distance_km, 0); -- one-way total
                v_final_price := v_base_price;
                if
                    upper(p_service_type) = 'AIRPORT'
                    and v_is_return = 'Y'
                then
                    v_final_price := v_final_price * 2;
                end if;

                v_model := 'KM';

      -- =========================================================
      -- DAILY
      -- السعر = 12 * سعر الساعة (1H)
      -- (هنا مفيش أيام ولا ضرب في nod — زي ما طلبتي)
      -- =========================================================
            elsif upper(p_service_type) = 'DAILY' then
                v_hour_1h := limo_pricing_pkg.get_hour_price(
                    p_car_type_id => c.car_type_id,
                    p_hours       => 1,
                    p_trip_date   => p_trip_date
                );

                if v_hour_1h is null then
                    continue; -- مفيش تسعير ساعة => متظهرش
                end if;
                v_currency := get_hour_currency(c.car_type_id, p_trip_date);
                v_base_price := v_hour_1h * 12;     -- ✅ المطلوب
                v_final_price := v_base_price;      -- مفيش return في DAILY
                v_model := 'DAILY_12H';
            else
                continue;
            end if;

            insert into limo_search_runtime (
                session_id,
                service_type,
                car_type_id,
                distance_km,
                hours,
                base_price,
                final_price,
                currency,
                price_model
            ) values ( p_session_id,
                       upper(p_service_type),
                       c.car_type_id,
                       p_distance_km,
                       p_hours,
                       round(v_base_price, 2),
                       round(v_final_price, 2),
                       v_currency,
                       v_model );

        end loop;

    -- بدون COMMIT
    end build_results;

end limo_pricing_engine;
/


-- sqlcl_snapshot {"hash":"b9f32f52e184ea45a60fe88c85fa9dffff6ee1b4","type":"PACKAGE_BODY","name":"LIMO_PRICING_ENGINE","schemaName":"WKSP_ELWAGHA50","sxml":""}