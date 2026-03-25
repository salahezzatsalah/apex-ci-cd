create index ix_invoice_payments_inv on
    invoice_payments (
        invoice_id
    );


-- sqlcl_snapshot {"hash":"3ba5bfe99ab3628d9c4518d7d5b90aee71d2c88b","type":"INDEX","name":"IX_INVOICE_PAYMENTS_INV","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IX_INVOICE_PAYMENTS_INV</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>INVOICE_PAYMENTS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>INVOICE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}