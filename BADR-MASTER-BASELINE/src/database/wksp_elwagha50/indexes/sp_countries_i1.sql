create unique index sp_countries_i1 on
    sp_countries (
        country_code
    );


-- sqlcl_snapshot {"hash":"bbb13ef3c27d092b88d32e24eaa47d2e208bd3db","type":"INDEX","name":"SP_COUNTRIES_I1","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>SP_COUNTRIES_I1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>SP_COUNTRIES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>COUNTRY_CODE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}