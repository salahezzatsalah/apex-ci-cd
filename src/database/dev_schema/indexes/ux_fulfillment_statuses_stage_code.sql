create unique index ux_fulfillment_statuses_stage_code on
    fulfillment_statuses (
        stage,
        status_code
    );


-- sqlcl_snapshot {"hash":"aa36632b1d631bcf4173734c84d119db4ae58a51","type":"INDEX","name":"UX_FULFILLMENT_STATUSES_STAGE_CODE","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>UX_FULFILLMENT_STATUSES_STAGE_CODE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>FULFILLMENT_STATUSES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STAGE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STATUS_CODE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}