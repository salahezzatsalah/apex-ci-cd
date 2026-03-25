-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463922720 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\sp_kb_stack_rank_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/sp_kb_stack_rank_seq.sql:null:1e642a7fcdd02e04d887f43e3872842253d76107:create

create sequence sp_kb_stack_rank_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder
nocycle nokeep noscale global;

