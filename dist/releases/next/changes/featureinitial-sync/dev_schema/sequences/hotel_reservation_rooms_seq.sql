-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463901910 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\hotel_reservation_rooms_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/hotel_reservation_rooms_seq.sql:null:884e6900f32ffaac39bf4f758c224c77fef830fc:create

create sequence hotel_reservation_rooms_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache
noorder nocycle nokeep noscale global;

