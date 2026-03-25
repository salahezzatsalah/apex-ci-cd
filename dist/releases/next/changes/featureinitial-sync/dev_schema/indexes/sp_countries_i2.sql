-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463836677 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\sp_countries_i2.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/sp_countries_i2.sql:null:dbe6a901718762c09d9d116141001cb4b4daba30:create

create unique index sp_countries_i2 on
    sp_countries (
        country_name
    );

