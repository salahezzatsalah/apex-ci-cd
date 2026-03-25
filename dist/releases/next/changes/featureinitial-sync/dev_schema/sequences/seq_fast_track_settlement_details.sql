-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463913535 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_fast_track_settlement_details.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_fast_track_settlement_details.sql:null:6925127a343db338c89206301e6709aecb7130fe:create

create sequence seq_fast_track_settlement_details minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache
20 noorder nocycle nokeep noscale global;

