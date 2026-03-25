-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463828964 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_ooc_priority.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_ooc_priority.sql:null:c49bade70631916483018955250f59c48a5263ce:create

create index ix_ooc_priority on
    ops_orders_current (
        priority_score
    desc );

