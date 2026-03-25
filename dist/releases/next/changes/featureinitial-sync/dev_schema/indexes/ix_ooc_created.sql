-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463828173 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_ooc_created.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_ooc_created.sql:null:67f678a994562083f73e22c8f72156f5634caaa8:create

create index ix_ooc_created on
    ops_orders_current (
        created_at
    desc );

