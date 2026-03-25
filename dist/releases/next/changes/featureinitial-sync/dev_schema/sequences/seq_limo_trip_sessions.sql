-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463917552 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_limo_trip_sessions.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_limo_trip_sessions.sql:null:64e4fba1f33e0f135e755d6aef9b3a5dbf7f393e:create

create sequence seq_limo_trip_sessions minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

