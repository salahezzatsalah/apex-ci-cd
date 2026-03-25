alter table limo_reservations
    add constraint fk_limo_ops
        foreign key ( ops_rep_id )
            references bs_employees ( id )
        enable;


-- sqlcl_snapshot {"hash":"5a3e9c360b14ed09ca08507294a9b4eb23816678","type":"REF_CONSTRAINT","name":"FK_LIMO_OPS","schemaName":"DEV_SCHEMA","sxml":""}