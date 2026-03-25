-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463912250 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_fast_track_commission_rules.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_fast_track_commission_rules.sql:null:48422c7a5bdb6300f829189d76297d29473d897b:create

create sequence seq_fast_track_commission_rules minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache
20 noorder nocycle nokeep noscale global;

