create index ix_lta_sub_res on
    limo_trip_accounting (
        sub_res_id
    );


-- sqlcl_snapshot {"hash":"8350ce0b4481cf765dca6ad759144046f530c927","type":"INDEX","name":"IX_LTA_SUB_RES","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IX_LTA_SUB_RES</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>LIMO_TRIP_ACCOUNTING</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SUB_RES_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}