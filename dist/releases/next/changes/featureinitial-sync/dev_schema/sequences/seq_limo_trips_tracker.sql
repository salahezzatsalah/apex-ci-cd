-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463917964 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_limo_trips_tracker.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_limo_trips_tracker.sql:null:ded3c0c7a90278dab34a3bbc7281ab0f08d90df7:create

create sequence seq_limo_trips_tracker minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

