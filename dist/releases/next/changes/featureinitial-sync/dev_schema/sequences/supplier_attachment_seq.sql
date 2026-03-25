-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463923183 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\supplier_attachment_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/supplier_attachment_seq.sql:null:6f204fb6696a59de2a65b9b5d1985ae46ae5aaad:create

create sequence supplier_attachment_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder
nocycle nokeep noscale global;

