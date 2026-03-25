-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463909647 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_bs_departments.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_bs_departments.sql:null:05bd8a1ebab025444176ca5f55ca83429ab8b442:create

create sequence seq_bs_departments minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

