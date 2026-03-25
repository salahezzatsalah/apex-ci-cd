-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463906211 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\pay_seqid.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/pay_seqid.sql:null:602a7406e38dc2761880b9db1990ddcc0128635c:create

create sequence pay_seqid minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle nokeep
noscale global;

