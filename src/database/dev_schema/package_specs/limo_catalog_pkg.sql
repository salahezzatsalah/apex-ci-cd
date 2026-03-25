create or replace package limo_catalog_pkg as

  /* ===========================

     CAR TYPES

  =========================== */

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
    );

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
    );

    procedure delete_car_type (
        p_car_type_id in varchar2
    );
  /* ===========================

     CATEGORIES

  =========================== */

    procedure add_category (
        p_name_ar in varchar2,
        p_name_en in varchar2,
        p_desc    in varchar2
    );

    procedure update_category (
        p_category_id in varchar2,
        p_name_ar     in varchar2,
        p_name_en     in varchar2,
        p_desc        in varchar2,
        p_active_yn   in char
    );

    procedure delete_category (
        p_category_id in varchar2
    );
  /* ===========================

     TRIP PRICES

  =========================== */
    procedure add_trip_price (
        p_car_type_id   in varchar2,
        p_price         in number,
        p_currency      in varchar2,
        p_exchange_rate in number,
        p_is_special    in char,
        p_start_date    in timestamp,
        p_end_date      in timestamp,
        p_notes         in varchar2
    );
  /* ===========================

     KM PRICES

  =========================== */
    procedure add_km_price (
        p_car_type_id in varchar2,
        p_price_km    in number,
        p_currency    in varchar2,
        p_notes       in varchar2
    );

    procedure disable_km_price (
        p_price_id in varchar2
    );


    /* ===============================
     Get Prices
  =============================== */

    function get_km_price (
        p_car_type_id in varchar2,
        p_trip_date   in date default sysdate
    ) return number;

    function get_trip_price (
        p_car_type_id in varchar2,
        p_trip_date   in date default sysdate
    ) return number;

    function get_hour_price (
        p_car_type_id in varchar2,
        p_hours       in number,
        p_trip_date   in date default sysdate
    ) return number;


  /* ===============================
     Set Prices (Versioned)
  =============================== */

    procedure set_km_price (
        p_car_type_id in varchar2,
        p_price_km    in number,
        p_currency    in varchar2,
        p_from_date   in date,
        p_notes       in varchar2 default null
    );

    procedure set_trip_price (
        p_car_type_id in varchar2,
        p_price       in number,
        p_currency    in varchar2,
        p_from_date   in date,
        p_to_date     in date default null,
        p_notes       in varchar2 default null
    );

    procedure set_hour_price (
        p_car_type_id in varchar2,
        p_price_hour  in number,
        p_currency    in varchar2,
        p_from_date   in date,
        p_notes       in varchar2 default null
    );

    procedure set_min_km (
        p_car_type_id in varchar2,
        p_min_km      in number,
        p_notes       in varchar2 default null
    );

    procedure build_results (
        p_session_id   in varchar2,
        p_service_type in varchar2, -- AIRPORT / TRANSFER / DAILY

        p_from_loc     in varchar2,
        p_to_loc       in varchar2,
        p_airport_code in varchar2,
        p_distance_km  in number,
        p_hours        in number,
        p_pax          in number,
        p_bags         in number,
        p_trip_date    in date
    );

end limo_catalog_pkg;
/


-- sqlcl_snapshot {"hash":"c6975a4c39d63c84258fea9a423bdc9feb0288d5","type":"PACKAGE_SPEC","name":"LIMO_CATALOG_PKG","schemaName":"DEV_SCHEMA","sxml":""}