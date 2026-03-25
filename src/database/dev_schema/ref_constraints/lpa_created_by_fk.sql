alter table limo_product_assignments
    add constraint lpa_created_by_fk
        foreign key ( created_by )
            references bs_employees ( id )
        disable;


-- sqlcl_snapshot {"hash":"619a74c4691102e3c5e4bddd0fb651430bfb32d6","type":"REF_CONSTRAINT","name":"LPA_CREATED_BY_FK","schemaName":"DEV_SCHEMA","sxml":""}