-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463895107 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\bs_employees_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/bs_employees_seq.sql:null:380b70fe04abf662577f9e5559c4b167a3d98ba7:create

create sequence bs_employees_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

