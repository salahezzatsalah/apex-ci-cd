-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463921317 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_sublimo_sub_res.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_sublimo_sub_res.sql:null:01da1ce6f882e9e0decfb48afaec34c68f1e7e0e:create

create sequence seq_sublimo_sub_res minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;

