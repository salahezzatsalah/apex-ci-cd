-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463820215 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_curt_user.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_curt_user.sql:null:7142ef5e6219a293334697b06e3912dc496fb286:create

create index ix_curt_user on
    customer_user_refresh_tokens (
        user_id
    );

