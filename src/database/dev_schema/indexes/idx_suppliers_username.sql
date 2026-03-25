create unique index idx_suppliers_username on
    suppliers (
        username
    );


-- sqlcl_snapshot {"hash":"7c896b142f03b6dd255044a6534b96e2b3a84124","type":"INDEX","name":"IDX_SUPPLIERS_USERNAME","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IDX_SUPPLIERS_USERNAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>SUPPLIERS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>USERNAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}