create index idx_clients_country on
    clients (
        phone_country_code
    );


-- sqlcl_snapshot {"hash":"b66b7f16618fc1c5e91cddb594a71af2aa145f18","type":"INDEX","name":"IDX_CLIENTS_COUNTRY","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IDX_CLIENTS_COUNTRY</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>CLIENTS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PHONE_COUNTRY_CODE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}