-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463903674 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\limo_assign_id_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/limo_assign_id_seq.sql:null:e85e1c5d259d28b52c486ebbfb4dde221ddfa8dd:create

create sequence limo_assign_id_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

