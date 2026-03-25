create unique index ux_invoice_main_res on
    invoices (
        main_res_id
    );


-- sqlcl_snapshot {"hash":"d09ffb3534e30b4777a232d868c61683c2a1f8f6","type":"INDEX","name":"UX_INVOICE_MAIN_RES","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>UX_INVOICE_MAIN_RES</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>INVOICES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MAIN_RES_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}