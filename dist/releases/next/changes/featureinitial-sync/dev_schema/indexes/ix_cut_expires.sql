-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463820650 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_cut_expires.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_cut_expires.sql:null:45217be9b4fd070e6e23901a2e24d00089d8f335:create

create index ix_cut_expires on
    customer_user_tokens ( sys_extract_utc(expires_at) );

