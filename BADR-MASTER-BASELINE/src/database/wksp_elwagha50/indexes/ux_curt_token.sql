create unique index ux_curt_token on
    customer_user_refresh_tokens (
        refresh_token
    );


-- sqlcl_snapshot {"hash":"34390c006777aa07ba85eb584eb13c34deadac14","type":"INDEX","name":"UX_CURT_TOKEN","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>UX_CURT_TOKEN</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>CUSTOMER_USER_REFRESH_TOKENS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>REFRESH_TOKEN</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}