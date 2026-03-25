-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463907075 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\prep_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/prep_seq.sql:null:594730e412c5dd78ce59608dc14dff33431faf40:create

create sequence prep_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder nocycle nokeep
noscale global;

