-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463906640 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\payments_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/payments_seq.sql:null:7ad3f9edc79cd607631dc856fbe9e6b55a17de99:create

create sequence payments_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

