-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463916675 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_limo_trip_collections.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_limo_trip_collections.sql:null:976b164e0707382988679f3a7881e4a70eae1a5a:create

create sequence seq_limo_trip_collections minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

