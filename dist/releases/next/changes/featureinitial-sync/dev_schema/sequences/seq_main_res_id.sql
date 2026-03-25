-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463918423 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_main_res_id.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_main_res_id.sql:null:1ece0c587f6ee532a604d568118ad30100f1eae8:create

create sequence seq_main_res_id minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

