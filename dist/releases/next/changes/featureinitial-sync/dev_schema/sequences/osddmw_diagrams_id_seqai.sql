-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463905775 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\osddmw_diagrams_id_seqai.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/osddmw_diagrams_id_seqai.sql:null:2c707710e73ed976a17c1fd3de289c60e26ae736:create

create sequence osddmw_diagrams_id_seqai minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

