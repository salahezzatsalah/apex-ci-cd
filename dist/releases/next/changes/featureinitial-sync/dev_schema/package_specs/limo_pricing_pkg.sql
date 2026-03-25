-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463882549 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\limo_pricing_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/limo_pricing_pkg.sql:null:ea0ffb451cf7b916c52761f3fc129fc087e36e60:create

create or replace package limo_pricing_pkg as

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

end limo_pricing_pkg;
/

