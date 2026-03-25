-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463892860 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\apartments_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/apartments_seq.sql:null:66488f9f33c28b9b1a209fec2820a20bb80a5ab0:create

create sequence apartments_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

