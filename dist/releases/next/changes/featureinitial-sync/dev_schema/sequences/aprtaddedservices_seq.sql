-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463894191 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\aprtaddedservices_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/aprtaddedservices_seq.sql:null:89608bf3d4410c968c814dd08f7e20bf9dad889e:create

create sequence aprtaddedservices_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

