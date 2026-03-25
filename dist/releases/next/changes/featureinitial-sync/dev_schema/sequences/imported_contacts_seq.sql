-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463903254 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\imported_contacts_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/imported_contacts_seq.sql:null:32a13d482bd697559201a751e41fb2b5d8578785:create

create sequence imported_contacts_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder
nocycle nokeep noscale global;

