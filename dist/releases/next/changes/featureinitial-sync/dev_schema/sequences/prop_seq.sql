-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463907538 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\prop_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/prop_seq.sql:null:9f668c20548ff889d9b4c8632839ce22aa0859a9:create

create sequence prop_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle nokeep
noscale global;

