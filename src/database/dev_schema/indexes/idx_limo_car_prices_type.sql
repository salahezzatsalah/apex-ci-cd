create index idx_limo_car_prices_type on
    limo_car_type_prices (
        car_type_id
    );


-- sqlcl_snapshot {"hash":"31d05f6d85665967215eb40a69b36511934a1488","type":"INDEX","name":"IDX_LIMO_CAR_PRICES_TYPE","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IDX_LIMO_CAR_PRICES_TYPE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>LIMO_CAR_TYPE_PRICES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CAR_TYPE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}