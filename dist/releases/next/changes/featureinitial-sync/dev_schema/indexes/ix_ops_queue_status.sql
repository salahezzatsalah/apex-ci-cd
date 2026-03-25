-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463832309 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_ops_queue_status.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_ops_queue_status.sql:null:8e6dc7203f26d63ea682c3a4e0c13d2a69b3c785:create

create index ix_ops_queue_status on
    ops_sync_queue (
        status,
        next_run_at
    );

