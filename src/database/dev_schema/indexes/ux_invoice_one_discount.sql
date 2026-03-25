create unique index ux_invoice_one_discount on
    invoice_adjustments (
        case
            adjustment_type
            when 'DISCOUNT' then
                    invoice_id
            else
                null
        end
    );


-- sqlcl_snapshot {"hash":"e392eb9b74c83e9e5c9aa738c4ac04581163880b","type":"INDEX","name":"UX_INVOICE_ONE_DISCOUNT","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>UX_INVOICE_ONE_DISCOUNT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>INVOICE_ADJUSTMENTS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>CASE \"ADJUSTMENT_TYPE\" WHEN 'DISCOUNT' THEN \"INVOICE_ID\" ELSE NULL END </DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}