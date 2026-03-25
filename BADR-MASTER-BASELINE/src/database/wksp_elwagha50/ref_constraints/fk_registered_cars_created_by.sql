alter table company_registered_cars
    add constraint fk_registered_cars_created_by
        foreign key ( created_by )
            references bs_employees ( id )
        disable;


-- sqlcl_snapshot {"hash":"b14f6be4778bab8be3c44d1ca34814747ef3ee55","type":"REF_CONSTRAINT","name":"FK_REGISTERED_CARS_CREATED_BY","schemaName":"WKSP_ELWAGHA50","sxml":""}