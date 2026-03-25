-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463894689 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\aprtcom_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/aprtcom_seq.sql:null:6f5bef5e78242d849bfcc73505d3d956f2065005:create

create sequence aprtcom_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

