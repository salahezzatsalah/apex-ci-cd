create index idx_company_drivers_dept on
    company_drivers (
        department_id
    );


-- sqlcl_snapshot {"hash":"0a7c3a1b144c20751822afdf45f8123475074d6f","type":"INDEX","name":"IDX_COMPANY_DRIVERS_DEPT","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IDX_COMPANY_DRIVERS_DEPT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>COMPANY_DRIVERS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>DEPARTMENT_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}