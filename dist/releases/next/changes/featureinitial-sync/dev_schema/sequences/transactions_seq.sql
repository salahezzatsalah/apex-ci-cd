-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463923635 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\transactions_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/transactions_seq.sql:null:fe15a3276b1d4034c0c078a8134b82be50194b98:create

create sequence transactions_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder nocycle
nokeep noscale global;

