-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463825446 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_lpa_driver_status.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_lpa_driver_status.sql:null:7b21c2507f200b1a816072ef31e3838f0bf98900:create

create index ix_lpa_driver_status on
    limo_product_assignments (
        driver_id,
        driver_status
    );

