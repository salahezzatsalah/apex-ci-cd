-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463902348 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\hotel_reservation_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/hotel_reservation_seq.sql:null:2a44248a7fb701ec74233d687030bc964b236250:create

create sequence hotel_reservation_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

