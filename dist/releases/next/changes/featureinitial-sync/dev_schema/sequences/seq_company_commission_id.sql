-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463910058 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_company_commission_id.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_company_commission_id.sql:null:faee3b9ff690f2683e088737807dacbc1c4790b2:create

create sequence seq_company_commission_id minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20
noorder nocycle nokeep noscale global;

