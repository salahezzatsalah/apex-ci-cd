-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463902791 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\hoteldocument_id.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/hoteldocument_id.sql:null:8bb5f4b1383c87e215521e7e5929d4f84f44f8ee:create

create sequence hoteldocument_id minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

