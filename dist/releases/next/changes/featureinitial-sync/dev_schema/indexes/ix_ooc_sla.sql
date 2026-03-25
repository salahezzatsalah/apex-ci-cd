-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463829838 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_ooc_sla.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_ooc_sla.sql:null:a5a00117ee7bb5695bc2289723f5da3addf74115:create

create index ix_ooc_sla on
    ops_orders_current (
        hours_to_service
    );

