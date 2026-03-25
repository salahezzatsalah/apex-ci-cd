-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463876014 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\client_delete_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/client_delete_pkg.sql:null:b05eaa4c3da1ab817f50911e6cd6d86b27a65563:create

create or replace package client_delete_pkg as
    procedure delete_user (
        p_token      in varchar2,
        p_debug_json out clob
    );

end client_delete_pkg;
/

