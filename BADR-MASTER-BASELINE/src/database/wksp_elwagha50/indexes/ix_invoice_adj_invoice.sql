create index ix_invoice_adj_invoice on
    invoice_adjustments (
        invoice_id
    );


-- sqlcl_snapshot {"hash":"129d60082f269f6670c96dc29546659c332da956","type":"INDEX","name":"IX_INVOICE_ADJ_INVOICE","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IX_INVOICE_ADJ_INVOICE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>INVOICE_ADJUSTMENTS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>INVOICE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}