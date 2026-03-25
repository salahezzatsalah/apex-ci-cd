create unique index ux_cu_client_active on
    customer_users (
        case
            status
            when 'ACTIVE' then
                    client_id
        end
    );


-- sqlcl_snapshot {"hash":"2fefabd7548d749ad1d06c45cf4f00e77d4f4c36","type":"INDEX","name":"UX_CU_CLIENT_ACTIVE","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>UX_CU_CLIENT_ACTIVE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>CUSTOMER_USERS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>CASE \"STATUS\" WHEN 'ACTIVE' THEN \"CLIENT_ID\" END </DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}