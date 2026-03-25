-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463912691 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_fast_track_reservations.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_fast_track_reservations.sql:null:68297e1db748851814e197557df280a004247b2a:create

create sequence seq_fast_track_reservations minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20
noorder nocycle nokeep noscale global;

