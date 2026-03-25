-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463893282 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\api_client_scopes_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/api_client_scopes_seq.sql:null:90af323cdeaea5517fb8fc7f25cebb8066bc3b89:create

create sequence api_client_scopes_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder
nocycle nokeep noscale global;

