-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463829388 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_ooc_service.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_ooc_service.sql:null:a9759b64174d6eb8f23db8a1f4ee4ffc458df4d7:create

create index ix_ooc_service on
    ops_orders_current (
        ref_table
    );

