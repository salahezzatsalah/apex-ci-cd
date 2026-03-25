-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463907974 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\reservationdocument_id.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/reservationdocument_id.sql:null:cb3b10f0fd3a84312602920d4d18cad1ff8fcbd4:create

create sequence reservationdocument_id minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

