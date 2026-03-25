-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463898504 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\crm_clients_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/crm_clients_seq.sql:null:b5967a8ae88e116e7eba11917625ee594e2fd298:create

create sequence crm_clients_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder nocycle
nokeep noscale global;

