-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463915251 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_limo_add_service.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_limo_add_service.sql:null:4d46f545a95c69fdb639011d8299b4ec8854d49d:create

create sequence seq_limo_add_service minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder
nocycle nokeep noscale global;

