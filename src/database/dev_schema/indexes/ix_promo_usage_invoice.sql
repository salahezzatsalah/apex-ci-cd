create index ix_promo_usage_invoice on
    promo_usage (
        invoice_id
    );


-- sqlcl_snapshot {"hash":"c0c3f193ff163f358361b034c5c366019c84ab5f","type":"INDEX","name":"IX_PROMO_USAGE_INVOICE","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IX_PROMO_USAGE_INVOICE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>PROMO_USAGE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>INVOICE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}