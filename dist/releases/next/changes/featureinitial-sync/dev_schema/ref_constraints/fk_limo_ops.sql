-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463890785 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\ref_constraints\fk_limo_ops.sql
-- sqlcl_snapshot src/database/dev_schema/ref_constraints/fk_limo_ops.sql:null:5a3e9c360b14ed09ca08507294a9b4eb23816678:create

alter table limo_reservations
    add constraint fk_limo_ops
        foreign key ( ops_rep_id )
            references bs_employees ( id )
        enable;

