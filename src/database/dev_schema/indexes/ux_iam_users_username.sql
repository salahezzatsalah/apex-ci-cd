create unique index ux_iam_users_username on
    iam_users ( upper(username) );


-- sqlcl_snapshot {"hash":"0b6312464007e3347adb09394fdd7e3181d09707","type":"INDEX","name":"UX_IAM_USERS_USERNAME","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>UX_IAM_USERS_USERNAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>IAM_USERS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>UPPER(\"USERNAME\")</DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}