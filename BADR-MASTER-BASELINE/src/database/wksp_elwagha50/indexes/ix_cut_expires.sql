create index ix_cut_expires on
    customer_user_tokens ( sys_extract_utc(expires_at) );


-- sqlcl_snapshot {"hash":"45217be9b4fd070e6e23901a2e24d00089d8f335","type":"INDEX","name":"IX_CUT_EXPIRES","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IX_CUT_EXPIRES</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>CUSTOMER_USER_TOKENS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>SYS_EXTRACT_UTC(\"EXPIRES_AT\")</DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}