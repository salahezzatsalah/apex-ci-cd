create index ix_api_client_tokens_client on
    api_client_tokens (
        client_id
    );


-- sqlcl_snapshot {"hash":"f5f598e77730bb9982ffa8bf55f335d36e5140f7","type":"INDEX","name":"IX_API_CLIENT_TOKENS_CLIENT","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IX_API_CLIENT_TOKENS_CLIENT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>API_CLIENT_TOKENS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CLIENT_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}