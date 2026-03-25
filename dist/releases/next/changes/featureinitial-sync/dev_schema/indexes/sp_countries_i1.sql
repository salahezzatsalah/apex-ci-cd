-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463836233 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\sp_countries_i1.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/sp_countries_i1.sql:null:bbb13ef3c27d092b88d32e24eaa47d2e208bd3db:create

create unique index sp_countries_i1 on
    sp_countries (
        country_code
    );

