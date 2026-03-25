-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463828565 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_ooc_main.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_ooc_main.sql:null:60a831ed3e8052860f210f9b8c570659da5adc63:create

create index ix_ooc_main on
    ops_orders_current (
        main_res_id
    );

