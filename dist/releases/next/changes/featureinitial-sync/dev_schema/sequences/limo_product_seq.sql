-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463904492 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\limo_product_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/limo_product_seq.sql:null:ca0f299d46ed463c2ac06990714fdd4a6f5fe07a:create

create sequence limo_product_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

