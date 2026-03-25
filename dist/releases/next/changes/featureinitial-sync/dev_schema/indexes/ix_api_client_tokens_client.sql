-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463819395 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_api_client_tokens_client.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_api_client_tokens_client.sql:null:f5f598e77730bb9982ffa8bf55f335d36e5140f7:create

create index ix_api_client_tokens_client on
    api_client_tokens (
        client_id
    );

