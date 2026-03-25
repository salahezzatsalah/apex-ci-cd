create index idx_company_drivers_employee_code on
    company_drivers (
        employee_code
    );


-- sqlcl_snapshot {"hash":"108c8b3002faf6e77c1c45324dd9baa856d01f44","type":"INDEX","name":"IDX_COMPANY_DRIVERS_EMPLOYEE_CODE","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IDX_COMPANY_DRIVERS_EMPLOYEE_CODE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>COMPANY_DRIVERS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>EMPLOYEE_CODE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}