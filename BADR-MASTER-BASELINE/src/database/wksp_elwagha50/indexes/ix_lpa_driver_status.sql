create index ix_lpa_driver_status on
    limo_product_assignments (
        driver_id,
        driver_status
    );


-- sqlcl_snapshot {"hash":"7b21c2507f200b1a816072ef31e3838f0bf98900","type":"INDEX","name":"IX_LPA_DRIVER_STATUS","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IX_LPA_DRIVER_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>LIMO_PRODUCT_ASSIGNMENTS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>DRIVER_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DRIVER_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}