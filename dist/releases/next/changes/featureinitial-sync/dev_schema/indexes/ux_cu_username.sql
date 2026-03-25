-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463840813 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_cu_username.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_cu_username.sql:null:ca35bc9e3351290f32dca8049111cc6f30d741a6:create

create unique index ux_cu_username on
    customer_users ( lower(username) );

