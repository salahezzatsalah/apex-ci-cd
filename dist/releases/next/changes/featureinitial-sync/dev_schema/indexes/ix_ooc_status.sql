-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463830290 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_ooc_status.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_ooc_status.sql:null:9172798eebfa428242ee655cd04d8dbdef0d40cf:create

create index ix_ooc_status on
    ops_orders_current (
        status_code
    );

