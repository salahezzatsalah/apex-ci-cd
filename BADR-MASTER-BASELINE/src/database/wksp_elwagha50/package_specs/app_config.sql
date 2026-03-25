create or replace package app_config as
    g_default_bucket constant varchar2(400) := 'ElWagha_ObjectStorage';
    g_credential_id constant varchar2(100) := 'o_storagekey';
end app_config;
/


-- sqlcl_snapshot {"hash":"0378c9362b200835a72b6722610286ac0fb550e3","type":"PACKAGE_SPEC","name":"APP_CONFIG","schemaName":"WKSP_ELWAGHA50","sxml":""}