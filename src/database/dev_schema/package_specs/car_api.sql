create or replace package car_api as
    procedure create_car_zip (
        p_car_id in varchar2
    );

end car_api;
/


-- sqlcl_snapshot {"hash":"690948576dc6b2617efa7fa10206510d9288410e","type":"PACKAGE_SPEC","name":"CAR_API","schemaName":"DEV_SCHEMA","sxml":""}