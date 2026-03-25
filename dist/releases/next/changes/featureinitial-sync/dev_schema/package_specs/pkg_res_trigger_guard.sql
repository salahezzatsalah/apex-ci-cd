-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463885771 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\pkg_res_trigger_guard.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/pkg_res_trigger_guard.sql:null:73df50c54f61cdddda299d5a88fb477447d390b8:create

create or replace package pkg_res_trigger_guard as
    g_running boolean := false;
end pkg_res_trigger_guard;
/

