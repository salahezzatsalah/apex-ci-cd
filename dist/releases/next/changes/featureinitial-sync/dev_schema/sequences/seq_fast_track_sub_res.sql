-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463914413 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_fast_track_sub_res.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_fast_track_sub_res.sql:null:77ff5ddc9e72078bed28b7e73dbe20c5105af47c:create

create sequence seq_fast_track_sub_res minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

