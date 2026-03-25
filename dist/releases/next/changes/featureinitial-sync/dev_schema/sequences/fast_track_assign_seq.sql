-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463901032 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\fast_track_assign_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/fast_track_assign_seq.sql:null:b70d4cf2a2c80dc6d5bc47388366347ca97f99d3:create

create sequence fast_track_assign_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

