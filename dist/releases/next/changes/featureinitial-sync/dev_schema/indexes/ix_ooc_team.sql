-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463830733 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_ooc_team.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_ooc_team.sql:null:5d3ee8723213aa32311d79aa07aceda1178870d7:create

create index ix_ooc_team on
    ops_orders_current (
        owner_team
    );

