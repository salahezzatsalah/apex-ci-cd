-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463920879 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_sublevel_attach_id.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_sublevel_attach_id.sql:null:fd6d1e226f14f6a5988a13e38a9e66477c946b86:create

create sequence seq_sublevel_attach_id minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder
nocycle nokeep noscale global;

