-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463915677 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\sequences\seq_limo_car_type_km_price.sql
-- sqlcl_snapshot src/database/dev_schema/sequences/seq_limo_car_type_km_price.sql:null:90a9fd575aed942dfabe8544a12d9d832fe6c7e0:create

create sequence seq_limo_car_type_km_price minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20
noorder nocycle nokeep noscale global;

