-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463896794 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\client_events_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/client_events_seq.sql:null:c5fe0b8eedcda74ede5b0c7a194a517b76f8baab:create

create sequence client_events_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

