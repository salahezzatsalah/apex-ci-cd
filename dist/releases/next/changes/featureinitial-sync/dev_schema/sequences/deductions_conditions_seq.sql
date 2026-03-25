-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463898936 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\deductions_conditions_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/deductions_conditions_seq.sql:null:60d480cfa5e78d26ba687147faf33e92186e9660:create

create sequence deductions_conditions_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

