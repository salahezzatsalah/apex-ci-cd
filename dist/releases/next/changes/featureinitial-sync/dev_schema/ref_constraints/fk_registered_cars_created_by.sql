-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463891628 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\ref_constraints\fk_registered_cars_created_by.sql
-- sqlcl_snapshot src/database/dev_schema/ref_constraints/fk_registered_cars_created_by.sql:null:b14f6be4778bab8be3c44d1ca34814747ef3ee55:create

alter table company_registered_cars
    add constraint fk_registered_cars_created_by
        foreign key ( created_by )
            references bs_employees ( id )
        disable;

