-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463920464 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_subft_sub_res.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_subft_sub_res.sql:null:4c3c8fec53bd86395558d4e6efe044a0bac153a2:create

create sequence seq_subft_sub_res minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

