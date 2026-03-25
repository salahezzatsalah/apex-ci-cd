create or replace package body limo_catalog_pkg as

/* =====================================================
   PRIVATE HELPERS (ONLY USED INTERNALLY)
===================================================== */

    procedure add_car_type (
        p_car_type_name      in limo_car_types.car_type_name%type,
        p_category           in limo_car_types.category%type,
        p_seats              in limo_car_types.seats%type,
        p_status             in limo_car_types.status%type,
        p_created_by         in varchar2 default user,
        p_model_year         in limo_car_types.model_year%type default null,
        p_max_passengers     in limo_car_types.max_passengers%type default null,
        p_max_luggage        in limo_car_types.max_luggage%type default null,
        p_personal_driver_yn in limo_car_types.personal_driver_yn%type default 'Y',
        p_main_photo         in varchar2 default null,
        p_photo_files        in varchar2 default null   -- ✅ صور متعددة (temp names مفصولين :)
    ) is

        l_car_type_id varchar2(255);
        l_blob        blob;
        l_filename    varchar2(255);
        l_extension   varchar2(20);
        l_object_name varchar2(400);
        l_public_url  varchar2(4000);
        l_file_names  apex_t_varchar2;
        l_temp_name   varchar2(4000);
        l_urls        apex_t_varchar2 := apex_t_varchar2();
        l_json        clob;
        l_json_vc     varchar2(7000);
    begin
  /* 1) Insert */
        insert into limo_car_types (
            car_type_name,
            category,
            seats,
            status,
            created_by,
            model_year,
            max_passengers,
            max_luggage,
            personal_driver_yn
        ) values ( p_car_type_name,
                   p_category,
                   p_seats,
                   p_status,
                   p_created_by,
                   p_model_year,
                   p_max_passengers,
                   p_max_luggage,
                   p_personal_driver_yn ) returning car_type_id into l_car_type_id;

  /* 2) MAIN photo */
        if trim(p_main_photo) is not null then
            begin
                select
                    blob_content,
                    filename
                into
                    l_blob,
                    l_filename
                from
                    apex_application_temp_files
                where
                    name = trim(p_main_photo);

                l_extension := lower(nvl(
                    regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                    '.jpg'
                ));
                l_object_name := 'CAR_TYPES_MAIN/'
                                 || l_car_type_id
                                 || l_extension;
                drive_crud_api.set_bucket(app_config.g_default_bucket);
                drive_crud_api.upload_file(
                    p_parent_name => 'CAR_TYPES_MAIN',
                    p_filename    => l_car_type_id || l_extension,
                    p_blob        => l_blob
                );

                l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                                || drive_crud_api.create_par(
                    p_object_name  => l_object_name,
                    p_par_name     => 'car-main-'
                                  || l_car_type_id
                                  || '-par',
                    p_time_expires => add_months(systimestamp, 12)
                );

                update limo_car_types
                set
                    main_photo_url = l_public_url
                where
                    car_type_id = l_car_type_id;

            exception
                when no_data_found then
                    null;
            end;

        end if;

  /* 3) MULTI photos -> PHOTO_URL */
/* 3) MULTI photos -> PHOTO_URL */
        if trim(p_photo_files) is not null then
            l_file_names := apex_string.split(
                replace(
                    trim(p_photo_files),
                    ',',
                    ':'
                ),  -- يدعم , و :
                ':'
            );

            drive_crud_api.set_bucket(app_config.g_default_bucket);
            for i in 1..l_file_names.count loop
                l_temp_name := trim(l_file_names(i));
                if l_temp_name is null then
                    continue;
                end if;
                begin
                    select
                        blob_content,
                        filename
                    into
                        l_blob,
                        l_filename
                    from
                        apex_application_temp_files
                    where
                        name = l_temp_name;

                exception
                    when no_data_found then
                        continue;
                end;

                l_extension := lower(nvl(
                    regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                    '.jpg'
                ));

    -- ✅ خليه Folder مختلف عن MAIN عشان ما يتلخبطش
                l_object_name := 'CAR_TYPES_PHOTOS/'
                                 || l_car_type_id
                                 || '_'
                                 || i
                                 || l_extension;
                drive_crud_api.upload_file(
                    p_parent_name => 'CAR_TYPES_PHOTOS',
                    p_filename    => l_car_type_id
                                  || '_'
                                  || i
                                  || l_extension,
                    p_blob        => l_blob
                );

                l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                                || drive_crud_api.create_par(
                    p_object_name  => l_object_name,
                    p_par_name     => 'car-photo-'
                                  || l_car_type_id
                                  || '-'
                                  || i
                                  || '-par',
                    p_time_expires => add_months(systimestamp, 12)
                );

                l_urls.extend;
                l_urls(l_urls.count) := l_public_url;
            end loop;

            if l_urls.count > 0 then
                l_json := '[';
                for j in 1..l_urls.count loop
                    if j > 1 then
                        l_json := l_json || ',';
                    end if;
                    l_json := l_json
                              || '"'
                              || replace(
                        l_urls(j),
                        '"',
                        '\"'
                    )
                              || '"';

                end loop;

                l_json := l_json || ']';
                update limo_car_types
                set
                    photo_url = dbms_lob.substr(l_json, 7000, 1)
                where
                    car_type_id = l_car_type_id;

            end if;

        end if;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20001, 'Car type creation failed: ' || sqlerrm);
    end add_car_type;

    procedure update_car_type (
        p_car_type_id        in limo_car_types.car_type_id%type,
        p_car_type_name      in limo_car_types.car_type_name%type,
        p_category           in limo_car_types.category%type,
        p_seats              in limo_car_types.seats%type,
        p_status             in limo_car_types.status%type,
        p_updated_by         in varchar2 default user,
        p_model_year         in number default null,
        p_max_passengers     in number default null,
        p_max_luggage        in number default null,
        p_personal_driver_yn in char default 'Y',
        p_main_photo         in varchar2 default null,
        p_gallery_photos     in varchar2 default null
    ) is

        l_url      varchar2(4000);
        l_files    apex_t_varchar2;
        l_urls     apex_t_varchar2 := apex_t_varchar2();
        l_json     clob;
        l_old_main varchar2(4000);
    begin

  /* 1) Update base info */
        update limo_car_types
        set
            car_type_name = p_car_type_name,
            category = p_category,
            seats = p_seats,
            status = p_status,
            model_year = p_model_year,
            max_passengers = p_max_passengers,
            max_luggage = p_max_luggage,
            personal_driver_yn = p_personal_driver_yn,
            updated = systimestamp,
            updated_by = p_updated_by
        where
            car_type_id = p_car_type_id;

        if sql%rowcount = 0 then
            raise_application_error(-21002, 'Car not found');
        end if;


  /* 2) Replace MAIN photo */
        if p_main_photo is not null then
            select
                main_photo_url
            into l_old_main
            from
                limo_car_types
            where
                car_type_id = p_car_type_id;

            if l_old_main is not null then
                media_pkg.delete_object(regexp_substr(l_old_main, 'CAR_TYPES_MAIN/[^?]+'));
            end if;

            l_url := media_pkg.upload_from_temp('CAR_TYPES_MAIN', p_main_photo, p_car_type_id || '.jpg', 'car-main');

            update limo_car_types
            set
                main_photo_url = l_url
            where
                car_type_id = p_car_type_id;

        end if;


  /* 3) Replace GALLERY */
        if p_gallery_photos is not null then
            l_files := apex_string.split(p_gallery_photos, ':');
            for i in 1..l_files.count loop
                l_url := media_pkg.upload_from_temp('CAR_TYPES_GALLERY',
                                                    l_files(i),
                                                    p_car_type_id
                                                    || '_'
                                                    || i
                                                    || '.jpg',
                                                    'car-gallery');

                if l_url is not null then
                    l_urls.extend;
                    l_urls(l_urls.count) := l_url;
                end if;

            end loop;

            l_json := '[';
            for i in 1..l_urls.count loop
                if i > 1 then
                    l_json := l_json || ',';
                end if;
                l_json := l_json
                          || '"'
                          || replace(
                    l_urls(i),
                    '"',
                    '\"'
                )
                          || '"';

            end loop;

            l_json := l_json || ']';
            update limo_car_types
            set
                photo_url = l_json
            where
                car_type_id = p_car_type_id;

        end if;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-21003, 'Update car type failed: ' || sqlerrm);
    end update_car_type;

    procedure delete_car_type (
        p_car_type_id in varchar2
    ) is
    begin

  -- Delete folder (all images)
        media_pkg.delete_folder('CAR_TYPES_MAIN/' || p_car_type_id);
        media_pkg.delete_folder('CAR_TYPES_GALLERY/' || p_car_type_id);
        delete from limo_car_types
        where
            car_type_id = p_car_type_id;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-21004, 'Delete car failed: ' || sqlerrm);
    end delete_car_type;

/* =====================================================
   CATEGORIES
===================================================== */

    procedure add_category (
        p_name_ar in varchar2,
        p_name_en in varchar2,
        p_desc    in varchar2
    ) is
    begin
        insert into limo_car_type_categories (
            category_name_ar,
            category_name_en,
            description
        ) values ( p_name_ar,
                   p_name_en,
                   p_desc );

        commit;
    end add_category;

    procedure update_category (
        p_category_id in varchar2,
        p_name_ar     in varchar2,
        p_name_en     in varchar2,
        p_desc        in varchar2,
        p_active_yn   in char
    ) is
    begin
        update limo_car_type_categories
        set
            category_name_ar = p_name_ar,
            category_name_en = p_name_en,
            description = p_desc,
            active_yn = p_active_yn,
            updated = systimestamp
        where
            category_id = p_category_id;

        commit;
    end update_category;

    procedure delete_category (
        p_category_id in varchar2
    ) is
    begin
        delete from limo_car_type_categories
        where
            category_id = p_category_id;

        commit;
    end delete_category;


/* =====================================================
   TRIP PRICES
===================================================== */

    procedure add_trip_price (
        p_car_type_id   in varchar2,
        p_price         in number,
        p_currency      in varchar2,
        p_exchange_rate in number,
        p_is_special    in char,
        p_start_date    in timestamp,
        p_end_date      in timestamp,
        p_notes         in varchar2
    ) is
    begin
        insert into limo_car_type_prices (
            car_type_id,
            price_per_trip,
            currency,
            exchange_rate,
            is_special,
            start_date,
            end_date,
            notes
        ) values ( p_car_type_id,
                   p_price,
                   p_currency,
                   p_exchange_rate,
                   p_is_special,
                   p_start_date,
                   p_end_date,
                   p_notes );

        commit;
    end add_trip_price;


/* =====================================================
   KM PRICES
===================================================== */

    procedure add_km_price (
        p_car_type_id in varchar2,
        p_price_km    in number,
        p_currency    in varchar2,
        p_notes       in varchar2
    ) is
    begin
        insert into limo_car_type_km_prices (
            car_type_id,
            price_per_km,
            currency,
            notes
        ) values ( p_car_type_id,
                   p_price_km,
                   p_currency,
                   p_notes );

        commit;
    end add_km_price;

    procedure disable_km_price (
        p_price_id in varchar2
    ) is
    begin
        update limo_car_type_km_prices
        set
            is_active = 'N'
        where
            price_id = p_price_id;

        commit;
    end disable_km_price;

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
        order by
            k.effective_from desc nulls last
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
                p.car_type_id = get_trip_price.p_car_type_id
            and trunc(p_trip_date) >= trunc(cast(p.start_date as date))
            and ( p.end_date is null
                  or trunc(p_trip_date) <= trunc(cast(p.end_date as date)) )
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
        if p_hours is null then
            return null;
        end if;
        select
            h.base_price
        into l_rate
        from
            limo_car_type_hourly_rates h
        where
                h.car_type_id = get_hour_price.p_car_type_id
            and h.is_active = 'Y'
            and trunc(p_trip_date) >= trunc(cast(h.effective_from as date))
            and ( h.effective_to is null
                  or trunc(p_trip_date) <= trunc(cast(h.effective_to as date)) )
        order by
            h.effective_from desc
        fetch first 1 row only;

        if l_rate is null then
            return null;
        end if;
        return round(l_rate * p_hours, 2);
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
        update limo_car_type_km_prices
        set
            is_active = 'N',
            effective_to = p_from_date - 1
        where
                car_type_id = p_car_type_id
            and is_active = 'Y'
            and trunc(cast(effective_from as date)) <= trunc(p_from_date);

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

    procedure set_min_km (
        p_car_type_id in varchar2,
        p_min_km      in number,
        p_notes       in varchar2 default null
    ) is
    begin
        apex_debug.message('SET_MIN_KM START');
        apex_debug.message('CAR_TYPE_ID = %s', p_car_type_id);
        apex_debug.message('MIN_KM      = %s', p_min_km);
        update limo_car_types
        set
            min_km = nvl(p_min_km, 0),
            updated = systimestamp,
            updated_by = nvl(
                v('APP_USER_ID'),
                user
            )
        where
            car_type_id = p_car_type_id;

        apex_debug.message('SQL%ROWCOUNT = %s', sql%rowcount);
        commit;
        apex_debug.message('SET_MIN_KM DONE');
    end;



/* =====================================================
   Build Search Results (Main Engine)
===================================================== */
    procedure build_results (
        p_session_id   in varchar2,
        p_service_type in varchar2,
        p_from_loc     in varchar2,
        p_to_loc       in varchar2,
        p_airport_code in varchar2,
        p_distance_km  in number,
        p_hours        in number,
        p_pax          in number,
        p_bags         in number,
        p_trip_date    in date
    ) is
        v_base_price  number;
        v_final_price number;
        v_currency    varchar2(10);
        v_model       varchar2(30);
    begin

  /* ===============================
     Reset Session
  =============================== */

        delete from limo_search_runtime
        where
            session_id = p_session_id;


  /* ===============================
     Loop Eligible Cars
  =============================== */
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
            v_base_price := null;
            v_final_price := null;
            v_currency := 'EGP';
            v_model := null;


    /* =====================================================
       AIRPORT / TRANSFER (KM)
    ===================================================== */
            if p_service_type in ( 'AIRPORT', 'TRANSFER' ) then
                v_base_price := limo_pricing_pkg.get_km_price(
                    p_car_type_id => c.car_type_id,
                    p_trip_date   => p_trip_date
                );

                if v_base_price is not null then
                    v_base_price := v_base_price * greatest(
                        nvl(p_distance_km, 0),
                        nvl(c.min_km, 0)
                    );

                    v_model := 'KM';
                end if;

    /* =====================================================
       DAILY / HOURLY
    ===================================================== */
            elsif p_service_type = 'DAILY' then
                v_base_price := limo_pricing_pkg.get_hour_price(
                    p_car_type_id => c.car_type_id,
                    p_hours       => p_hours,
                    p_trip_date   => p_trip_date
                );

                if v_base_price is not null then
                    v_model := 'HOURLY';
                end if;


    /* =====================================================
       FULL DAY / PACKAGE
    ===================================================== */
            elsif p_service_type = 'PACKAGE' then
                v_base_price := limo_pricing_pkg.get_trip_price(
                    p_car_type_id => c.car_type_id,
                    p_trip_date   => p_trip_date
                );

                if v_base_price is not null then
                    v_model := 'TRIP';
                end if;
            end if;


    /* ===============================
       Skip If No Price
    =============================== */
            if v_base_price is null then
                continue;
            end if;


    /* ===============================
       Apply Business Rules
    =============================== */

            v_final_price := v_base_price;

    /* Peak hours */
            if p_trip_date is not null then
                if to_char(p_trip_date, 'HH24') between '18' and '23' then
                    v_final_price := v_final_price * 1.15;
                end if;
            end if;

    /* Large group surcharge */
            if p_pax >= 5 then
                v_final_price := v_final_price * 1.10;
            end if;


    /* ===============================
       Store Runtime Result
    =============================== */

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
                       p_service_type,
                       c.car_type_id,
                       p_distance_km,
                       p_hours,
                       round(v_base_price, 2),
                       round(v_final_price, 2),
                       v_currency,
                       v_model );

        end loop;

        commit;
    end build_results;

end limo_catalog_pkg;
/


-- sqlcl_snapshot {"hash":"e8ef77258f564545db8803f82d4c5c5935fc6bea","type":"PACKAGE_BODY","name":"LIMO_CATALOG_PKG","schemaName":"DEV_SCHEMA","sxml":""}