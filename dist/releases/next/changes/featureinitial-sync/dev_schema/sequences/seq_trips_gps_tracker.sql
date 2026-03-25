-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463922223 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_trips_gps_tracker.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_trips_gps_tracker.sql:null:f207317fca13bd81d0ebcdf35f19f245f6e7e706:create

create sequence seq_trips_gps_tracker minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder
nocycle nokeep noscale global;

