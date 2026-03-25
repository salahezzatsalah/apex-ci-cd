-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463813045 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_currencies_status.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_currencies_status.sql:null:aeb434a89f106d15ba1237eb93a8425226b4e6df:create

create index idx_currencies_status on
    currencies (
        status
    );

