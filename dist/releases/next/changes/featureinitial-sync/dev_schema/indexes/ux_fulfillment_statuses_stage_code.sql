-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463845387 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_fulfillment_statuses_stage_code.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_fulfillment_statuses_stage_code.sql:null:aa36632b1d631bcf4173734c84d119db4ae58a51:create

create unique index ux_fulfillment_statuses_stage_code on
    fulfillment_statuses (
        stage,
        status_code
    );

