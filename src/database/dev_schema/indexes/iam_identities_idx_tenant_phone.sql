create index iam_identities_idx_tenant_phone on
    iam_identities (
        tenant_id,
        phone_number
    );


-- sqlcl_snapshot {"hash":"43c8c57d96db4c55c5ce2f296dba3d8d882967d4","type":"INDEX","name":"IAM_IDENTITIES_IDX_TENANT_PHONE","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IAM_IDENTITIES_IDX_TENANT_PHONE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>IAM_IDENTITIES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TENANT_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PHONE_NUMBER</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}