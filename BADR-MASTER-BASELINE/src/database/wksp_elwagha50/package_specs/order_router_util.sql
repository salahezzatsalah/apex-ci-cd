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


-- sqlcl_snapshot {"hash":"6b9bef95c0e6d0bf04f291df194471a30f25c9a4","type":"PACKAGE_SPEC","name":"ORDER_ROUTER_UTIL","schemaName":"WKSP_ELWAGHA50","sxml":""}