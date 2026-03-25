-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463892454 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\ref_constraints\suppliers.supplier_types.sql
-- sqlcl_snapshot src/database/dev_schema/ref_constraints/suppliers.supplier_types.sql:null:2bfb2c768af9a29cb92988124f4d22a3396ebfdb:create

alter table suppliers
    add
        foreign key ( supplier_type_id )
            references supplier_types ( supplier_type_id )
        enable;

