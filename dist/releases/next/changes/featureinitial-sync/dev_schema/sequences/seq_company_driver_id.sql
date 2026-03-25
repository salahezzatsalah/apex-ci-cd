-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463910791 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_company_driver_id.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_company_driver_id.sql:null:beda58330d1b198f31fe1b67f144b6cda6f309cf:create

create sequence seq_company_driver_id minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder
nocycle nokeep noscale global;

