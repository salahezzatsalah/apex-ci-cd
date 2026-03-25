-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463875205 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\car_api.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/car_api.sql:null:690948576dc6b2617efa7fa10206510d9288410e:create

create or replace package car_api as
    procedure create_car_zip (
        p_car_id in varchar2
    );

end car_api;
/

