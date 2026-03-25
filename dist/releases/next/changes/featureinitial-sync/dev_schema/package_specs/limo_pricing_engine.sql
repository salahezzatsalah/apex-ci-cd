-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463881755 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\limo_pricing_engine.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/limo_pricing_engine.sql:null:931260af6a766143f0451bbbc1be2b358b95007a:create

create or replace package limo_pricing_engine as
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
    );

end limo_pricing_engine;
/

