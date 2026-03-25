-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463809528 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_assignments_curr.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_assignments_curr.sql:null:542d723f1d7cd2fcdf8db66190f343bfeec5f3f7:create

create index idx_assignments_curr on
    limo_product_assignments (
        product_id,
        driver_status
    );

