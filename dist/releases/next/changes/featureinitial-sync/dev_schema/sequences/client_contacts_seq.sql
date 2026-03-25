-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463896359 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\client_contacts_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/client_contacts_seq.sql:null:973b6cfe5aeb78da405dabfa8d623f34178655f6:create

create sequence client_contacts_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

