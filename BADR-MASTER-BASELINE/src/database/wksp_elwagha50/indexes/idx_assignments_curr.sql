create index idx_assignments_curr on
    limo_product_assignments (
        product_id,
        driver_status
    );


-- sqlcl_snapshot {"hash":"542d723f1d7cd2fcdf8db66190f343bfeec5f3f7","type":"INDEX","name":"IDX_ASSIGNMENTS_CURR","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IDX_ASSIGNMENTS_CURR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>LIMO_PRODUCT_ASSIGNMENTS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PRODUCT_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DRIVER_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}