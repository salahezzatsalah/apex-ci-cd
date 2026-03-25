-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463873625 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\app_config.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/app_config.sql:null:0378c9362b200835a72b6722610286ac0fb550e3:create

create or replace package app_config as
    g_default_bucket constant varchar2(400) := 'ElWagha_ObjectStorage';
    g_credential_id constant varchar2(100) := 'o_storagekey';
end app_config;
/

