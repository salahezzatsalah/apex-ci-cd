-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463827767 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_ooc_assigned.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_ooc_assigned.sql:null:3eb56b3f3de7c311a2f0d25befd901e1b2ace21c:create

create index ix_ooc_assigned on
    ops_orders_current (
        assigned_to_name
    );

