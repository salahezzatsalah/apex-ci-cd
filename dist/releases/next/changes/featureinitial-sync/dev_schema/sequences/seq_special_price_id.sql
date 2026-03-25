-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463919255 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_special_price_id.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_special_price_id.sql:null:9e4f64e544bb7830b78e7bf8fde36389e18d9a70:create

create sequence seq_special_price_id minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

