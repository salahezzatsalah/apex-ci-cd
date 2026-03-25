-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463919678 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_subft_files.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_subft_files.sql:null:6ef4a55eb250159cc0b1f35bc8b93c1ae51525fc:create

create sequence seq_subft_files minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder nocycle
nokeep noscale global;

