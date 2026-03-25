-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463899384 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\dept_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/dept_seq.sql:null:cafea7cd40349f6362a87a2381357cc3917f58a3:create

create sequence dept_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder nocycle nokeep
noscale global;

