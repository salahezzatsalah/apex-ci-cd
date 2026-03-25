-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463831876 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_ops_err_status.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_ops_err_status.sql:null:967b1a5685dfcbc84aa9adc93e165f9573c29ec0:create

create index ix_ops_err_status on
    ops_sync_errors (
        status
    );

