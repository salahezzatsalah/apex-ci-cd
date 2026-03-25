-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463909193 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_airports.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_airports.sql:null:b69762396cf506b7efe771aa8aadde2e6109e1cc:create

create sequence seq_airports minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

