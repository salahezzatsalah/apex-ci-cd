-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463913121 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_fast_track_service_catalog.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_fast_track_service_catalog.sql:null:c3878f966b612df9557e599cdc3bed7485c8381f:create

create sequence seq_fast_track_service_catalog minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache
20 noorder nocycle nokeep noscale global;

