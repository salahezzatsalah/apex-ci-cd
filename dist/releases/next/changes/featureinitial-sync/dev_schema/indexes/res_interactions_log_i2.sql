-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463835711 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\res_interactions_log_i2.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/res_interactions_log_i2.sql:null:3a3415453862ce98a066c45574894bfa1c86dddc:create

create index res_interactions_log_i2 on
    reservation_interactions_log (
        user_id
    );

