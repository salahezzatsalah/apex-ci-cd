-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463813447 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_lctp_active_price.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_lctp_active_price.sql:null:5a608dda2225775e5d0daf861f61e28092b23304:create

create index idx_lctp_active_price on
    limo_car_type_prices (
        car_type_id,
        is_special,
    sys_extract_utc(start_date),
    sys_extract_utc(end_date) );

