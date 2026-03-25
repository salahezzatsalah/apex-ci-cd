alter table limo_reservations
    add constraint fk_limo_sales
        foreign key ( sales_rep_id )
            references bs_employees ( id )
        enable;


-- sqlcl_snapshot {"hash":"1158541ad9294abaa4630a8dafabf50804af7260","type":"REF_CONSTRAINT","name":"FK_LIMO_SALES","schemaName":"WKSP_ELWAGHA50","sxml":""}