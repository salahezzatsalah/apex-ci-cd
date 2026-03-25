-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463892033 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\ref_constraints\lpa_created_by_fk.sql
-- sqlcl_snapshot src/database/dev_schema/ref_constraints/lpa_created_by_fk.sql:null:619a74c4691102e3c5e4bddd0fb651430bfb32d6:create

alter table limo_product_assignments
    add constraint lpa_created_by_fk
        foreign key ( created_by )
            references bs_employees ( id )
        disable;

