-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463914825 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_hotel_services.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_hotel_services.sql:null:a775d88a9c0bb5b9d234909d4b056cbaa7ab2ef3:create

create sequence seq_hotel_services minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

