-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463814525 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_limo_car_prices_type.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_limo_car_prices_type.sql:null:31d05f6d85665967215eb40a69b36511934a1488:create

create index idx_limo_car_prices_type on
    limo_car_type_prices (
        car_type_id
    );

