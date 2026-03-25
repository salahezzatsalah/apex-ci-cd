-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463826336 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_lta_sub_res.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_lta_sub_res.sql:null:8350ce0b4481cf765dca6ad759144046f530c927:create

create index ix_lta_sub_res on
    limo_trip_accounting (
        sub_res_id
    );

