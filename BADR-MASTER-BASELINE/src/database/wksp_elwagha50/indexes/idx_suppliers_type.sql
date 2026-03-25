create index idx_suppliers_type on
    suppliers (
        supplier_type_id
    );


-- sqlcl_snapshot {"hash":"9eed0b28d4482183467c690803e6d8022d8f16a5","type":"INDEX","name":"IDX_SUPPLIERS_TYPE","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IDX_SUPPLIERS_TYPE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>SUPPLIERS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SUPPLIER_TYPE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}