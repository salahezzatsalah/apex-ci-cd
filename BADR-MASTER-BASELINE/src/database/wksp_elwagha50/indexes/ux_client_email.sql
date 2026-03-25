create unique index ux_client_email on
    client_contacts (
        case
            contact_type
            when 'EMAIL' then
                lower(contact_value)
        end
    );


-- sqlcl_snapshot {"hash":"e7a9ee1e8e7b1f70b03edc8c1440ccd8a2165c69","type":"INDEX","name":"UX_CLIENT_EMAIL","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>UX_CLIENT_EMAIL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>CLIENT_CONTACTS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>CASE \"CONTACT_TYPE\" WHEN 'EMAIL' THEN LOWER(\"CONTACT_VALUE\") END </DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}