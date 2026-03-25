create index idx_company_drivers_join_date on
    company_drivers (
        join_date
    );


-- sqlcl_snapshot {"hash":"f6bab4fa86017df1b318c574622863f182a4b465","type":"INDEX","name":"IDX_COMPANY_DRIVERS_JOIN_DATE","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IDX_COMPANY_DRIVERS_JOIN_DATE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>COMPANY_DRIVERS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>JOIN_DATE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}