create index idx_lctp_active_price on
    limo_car_type_prices (
        car_type_id,
        is_special,
    sys_extract_utc(start_date),
    sys_extract_utc(end_date) );


-- sqlcl_snapshot {"hash":"5a608dda2225775e5d0daf861f61e28092b23304","type":"INDEX","name":"IDX_LCTP_ACTIVE_PRICE","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IDX_LCTP_ACTIVE_PRICE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>LIMO_CAR_TYPE_PRICES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CAR_TYPE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>IS_SPECIAL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>SYS_EXTRACT_UTC(\"START_DATE\")</DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>SYS_EXTRACT_UTC(\"END_DATE\")</DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}