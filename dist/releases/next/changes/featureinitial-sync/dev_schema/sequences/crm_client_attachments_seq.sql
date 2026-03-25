-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463897617 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\crm_client_attachments_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/crm_client_attachments_seq.sql:null:ade8f11e52d4e5d26c99b4f0cf10bedd717880ff:create

create sequence crm_client_attachments_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache
noorder nocycle nokeep noscale global;

