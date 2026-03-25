-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463893732 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\aprt_reservations_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/aprt_reservations_seq.sql:null:c9ad94c501873a69846c53e17050c635a58bbe8c:create

create sequence aprt_reservations_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

