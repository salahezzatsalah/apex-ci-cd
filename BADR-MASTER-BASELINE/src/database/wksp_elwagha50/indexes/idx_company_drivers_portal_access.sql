create index idx_company_drivers_portal_access on
    company_drivers (
        has_portal_access
    );


-- sqlcl_snapshot {"hash":"630113ab2d8c66a8488beb3059288daef8847205","type":"INDEX","name":"IDX_COMPANY_DRIVERS_PORTAL_ACCESS","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IDX_COMPANY_DRIVERS_PORTAL_ACCESS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>COMPANY_DRIVERS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>HAS_PORTAL_ACCESS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}