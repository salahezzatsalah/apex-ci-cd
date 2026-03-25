create unique index ux_fast_track_service_name on
    fast_track_service_catalog (
        service_name
    );


-- sqlcl_snapshot {"hash":"1bb87ae8300e15d3713a4d9384704c450f9025ce","type":"INDEX","name":"UX_FAST_TRACK_SERVICE_NAME","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>UX_FAST_TRACK_SERVICE_NAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>FAST_TRACK_SERVICE_CATALOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SERVICE_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}