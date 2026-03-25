create or replace package client_delete_pkg as
    procedure delete_user (
        p_token      in varchar2,
        p_debug_json out clob
    );

end client_delete_pkg;
/


-- sqlcl_snapshot {"hash":"b05eaa4c3da1ab817f50911e6cd6d86b27a65563","type":"PACKAGE_SPEC","name":"CLIENT_DELETE_PKG","schemaName":"DEV_SCHEMA","sxml":""}