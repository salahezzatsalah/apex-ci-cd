-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463916161 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_limo_settlements.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_limo_settlements.sql:null:cd473641338181a93f25d24b9f4f4a20eab082a8:create

create sequence seq_limo_settlements minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder
nocycle nokeep noscale global;

