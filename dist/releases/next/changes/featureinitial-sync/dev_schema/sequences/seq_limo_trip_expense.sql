-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463917133 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_limo_trip_expense.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_limo_trip_expense.sql:null:dc76f04fd98f66c9698fb26f595d4f352cd3e2fe:create

create sequence seq_limo_trip_expense minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

