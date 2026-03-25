-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463905319 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\order_item_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/order_item_seq.sql:null:068b7aa692414a528ede52c381d2107e4f063bef:create

create sequence order_item_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder nocycle
nokeep noscale global;

