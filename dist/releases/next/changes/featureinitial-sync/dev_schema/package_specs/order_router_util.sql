-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463884956 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\order_router_util.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/order_router_util.sql:null:6b9bef95c0e6d0bf04f291df194471a30f25c9a4:create

create or replace package order_router_util as
    function details_url (
        p_ref_table in varchar2,
        p_ref_id    in varchar2
    ) return varchar2;

    function assign_url (
        p_ref_table in varchar2,
        p_ref_id    in varchar2
    ) return varchar2;

end order_router_util;
/

