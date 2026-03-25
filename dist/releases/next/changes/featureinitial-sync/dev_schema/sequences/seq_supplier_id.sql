-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463921783 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_supplier_id.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_supplier_id.sql:null:168c54adbf6f67c6e6b9ddcdae3326f971c9aaa4:create

create sequence seq_supplier_id minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder nocycle
nokeep noscale global;

