create or replace package limo_trip_pkg as
    procedure start_trip (
        p_product_id    in varchar2,
        p_assignment_id in varchar2,
        p_driver_id     in varchar2,
        p_used_car_id   in varchar2,
        p_executed_day  in date,
        p_created_by    in varchar2,
        p_trip_id       out varchar2
    );

end limo_trip_pkg;
/


-- sqlcl_snapshot {"hash":"4b83e6063da8bbde4cc17a02f417f24f9042e881","type":"PACKAGE_SPEC","name":"LIMO_TRIP_PKG","schemaName":"DEV_SCHEMA","sxml":""}