-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463911840 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_driver_assigned_cars.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_driver_assigned_cars.sql:null:30a8a93665066243cc4dad3049d92b002be5131b:create

create sequence seq_driver_assigned_cars minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder
nocycle nokeep noscale global;

