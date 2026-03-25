-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463908744 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\room_attachments_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/room_attachments_seq.sql:null:0ec90853957937662f2c7725f4e97355267e19e3:create

create sequence room_attachments_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder
nocycle nokeep noscale global;

