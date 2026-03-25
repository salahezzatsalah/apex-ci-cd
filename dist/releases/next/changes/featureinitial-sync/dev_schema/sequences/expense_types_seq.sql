-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463900626 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\expense_types_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/expense_types_seq.sql:null:d6d9bb300a62b1ec8c94bb62931f6d42a5639a09:create

create sequence expense_types_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder
nocycle nokeep noscale global;

