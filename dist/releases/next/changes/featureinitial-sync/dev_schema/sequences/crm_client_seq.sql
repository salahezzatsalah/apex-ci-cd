-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463898041 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\crm_client_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/crm_client_seq.sql:null:80510e7b6277d0a974319dce2d96465b7977b314:create

create sequence crm_client_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

