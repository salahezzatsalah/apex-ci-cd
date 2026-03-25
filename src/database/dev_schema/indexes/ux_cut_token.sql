create unique index ux_cut_token on
    customer_user_tokens (
        access_token
    );


-- sqlcl_snapshot {"hash":"85c25430df59152ab2c11e54c349c0dd658a3f03","type":"INDEX","name":"UX_CUT_TOKEN","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>UX_CUT_TOKEN</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>CUSTOMER_USER_TOKENS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ACCESS_TOKEN</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}