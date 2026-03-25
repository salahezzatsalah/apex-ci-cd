-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463895929 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\client_code_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/client_code_seq.sql:null:dc5b2512c4be6107a8a07541adc7def45f487ce8:create

create sequence client_code_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

