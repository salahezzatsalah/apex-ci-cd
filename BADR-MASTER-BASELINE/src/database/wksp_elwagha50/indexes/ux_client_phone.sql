create unique index ux_client_phone on
    client_contacts (
        case
            contact_type
            when 'PHONE' then
                    contact_value
        end
    );


-- sqlcl_snapshot {"hash":"22fae04180a89ea6df30c20c4e94c42c03f7d0dd","type":"INDEX","name":"UX_CLIENT_PHONE","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>UX_CLIENT_PHONE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>CLIENT_CONTACTS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>CASE \"CONTACT_TYPE\" WHEN 'PHONE' THEN \"CONTACT_VALUE\" END </DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}