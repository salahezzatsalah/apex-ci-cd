-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463895520 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\chat_id.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/chat_id.sql:null:7193685f63dc2e811c0f05ed3203bfc8645a909a:create

create sequence chat_id minvalue 1 maxvalue 9999999999999 increment by 1 /* start with n */ cache 20 noorder nocycle nokeep noscale global
;

