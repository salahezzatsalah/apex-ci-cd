-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463891212 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\ref_constraints\fk_limo_sales.sql
-- sqlcl_snapshot src/database/dev_schema/ref_constraints/fk_limo_sales.sql:null:1158541ad9294abaa4630a8dafabf50804af7260:create

alter table limo_reservations
    add constraint fk_limo_sales
        foreign key ( sales_rep_id )
            references bs_employees ( id )
        enable;

