-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463913967 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_fast_track_settlements.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_fast_track_settlements.sql:null:db70394abe53a7a10ba2df6674b83ebc2884040d:create

create sequence seq_fast_track_settlements minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20
noorder nocycle nokeep noscale global;

