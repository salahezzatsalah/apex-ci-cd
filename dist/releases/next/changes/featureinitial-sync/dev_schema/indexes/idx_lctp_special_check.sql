-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463813935 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_lctp_special_check.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_lctp_special_check.sql:null:0a92ae66b9619781b1a985ee0d15dc95c6ccb603:create

create index idx_lctp_special_check on
    limo_car_type_prices (
        car_type_id,
        is_special,
    sys_extract_utc(start_date) );

