alter table default_currency
    add
        foreign key ( currency_code )
            references currencies ( currency_code )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"89c951a339fc5735b3cfe48d113cc6b5af568c14","type":"REF_CONSTRAINT","name":"DEFAULT_CURRENCY.CURRENCIES","schemaName":"DEV_SCHEMA","sxml":""}