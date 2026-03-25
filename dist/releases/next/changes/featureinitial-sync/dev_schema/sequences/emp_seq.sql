-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463900220 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\emp_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/emp_seq.sql:null:1ada805082585b46239eeb3b653af56acc6be4bd:create

create sequence emp_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle nokeep
noscale global;

