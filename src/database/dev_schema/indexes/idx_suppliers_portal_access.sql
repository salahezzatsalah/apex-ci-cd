create index idx_suppliers_portal_access on
    suppliers (
        has_portal_access
    );


-- sqlcl_snapshot {"hash":"1e67f8bea91481b332ed0d6ca1faa61838077958","type":"INDEX","name":"IDX_SUPPLIERS_PORTAL_ACCESS","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IDX_SUPPLIERS_PORTAL_ACCESS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>SUPPLIERS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>HAS_PORTAL_ACCESS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}