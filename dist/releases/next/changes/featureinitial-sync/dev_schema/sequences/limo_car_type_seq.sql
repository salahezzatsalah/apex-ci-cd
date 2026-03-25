-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463904079 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\limo_car_type_seq.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/limo_car_type_seq.sql:null:c8d6da3c78d2c54838ab9447158c62364cac6591:create

create sequence limo_car_type_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;

