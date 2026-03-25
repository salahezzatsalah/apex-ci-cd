-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463901470 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\hotel_res_res_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/hotel_res_res_seq.sql:null:a26174ef1fec20185dc6c1212c8ecd72f487344e:create

create sequence hotel_res_res_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

