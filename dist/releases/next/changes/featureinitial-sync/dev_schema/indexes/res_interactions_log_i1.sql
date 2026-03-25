-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463835091 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\res_interactions_log_i1.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/res_interactions_log_i1.sql:null:1c59b958f722cbf003ec3ae895a016fc875d3bc9:create

create index res_interactions_log_i1 on
    reservation_interactions_log (
        reservation_id
    );

