-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463821042 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_cut_user.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_cut_user.sql:null:d27deb27bfee7eadd55ba2d8bd37a497ab3fcb81:create

create index ix_cut_user on
    customer_user_tokens (
        user_id
    );

