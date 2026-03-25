create index idx_company_drivers_email on
    company_drivers (
        email
    );


-- sqlcl_snapshot {"hash":"291a0f396bbfd3c492a6f13d99eccaf95e59c47c","type":"INDEX","name":"IDX_COMPANY_DRIVERS_EMAIL","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IDX_COMPANY_DRIVERS_EMAIL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>COMPANY_DRIVERS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>EMAIL</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}