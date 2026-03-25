-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463918837 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_otp_id.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_otp_id.sql:null:fde5cfe5fbc2cf88a3e32f9f41c2237d8cb8f3a2:create

create sequence seq_otp_id minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

