create unique index ux_api_client_tokens_jti on
    api_client_tokens (
        jti
    );


-- sqlcl_snapshot {"hash":"f783dad910d5bda4848f37e465029bf092e9e626","type":"INDEX","name":"UX_API_CLIENT_TOKENS_JTI","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>UX_API_CLIENT_TOKENS_JTI</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>API_CLIENT_TOKENS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>JTI</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}