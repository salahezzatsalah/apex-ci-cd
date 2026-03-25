-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463899798 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\drive_items_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/drive_items_seq.sql:null:d67ed872d632b79eba7bc236189dcb85e7bbf088:create

create sequence drive_items_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

