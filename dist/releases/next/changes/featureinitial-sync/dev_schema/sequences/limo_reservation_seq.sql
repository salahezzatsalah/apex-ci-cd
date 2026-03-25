-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463904893 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\limo_reservation_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/limo_reservation_seq.sql:null:d8fbc1c256eb52dc8d26ccaf7756351f0303b959:create

create sequence limo_reservation_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

