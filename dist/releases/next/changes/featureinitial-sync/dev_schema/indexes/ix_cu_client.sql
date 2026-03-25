-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463819791 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_cu_client.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_cu_client.sql:null:76059a6ac0fdedceebe1f3d732839f10c31fae75:create

create index ix_cu_client on
    customer_users (
        client_id
    );

