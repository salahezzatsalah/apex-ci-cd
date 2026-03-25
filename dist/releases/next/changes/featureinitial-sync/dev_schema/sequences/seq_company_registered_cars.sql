-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463911374 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_company_registered_cars.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_company_registered_cars.sql:null:db74ea50b70d8af4e7371f155c4222f7c85cc5ca:create

create sequence seq_company_registered_cars minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20
noorder nocycle nokeep noscale global;

