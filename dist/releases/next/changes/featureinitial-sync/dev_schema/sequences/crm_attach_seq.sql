-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463897205 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\crm_attach_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/crm_attach_seq.sql:null:13cbbcd1d130748ebfd164ec2a975679a786e2a7:create

create sequence crm_attach_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder nocycle
nokeep noscale global;

