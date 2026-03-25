-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463809943 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_clients_country.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_clients_country.sql:null:b66b7f16618fc1c5e91cddb594a71af2aa145f18:create

create index idx_clients_country on
    clients (
        phone_country_code
    );

