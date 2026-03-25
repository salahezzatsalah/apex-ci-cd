-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463848075 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_invoice_one_discount.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_invoice_one_discount.sql:null:e392eb9b74c83e9e5c9aa738c4ac04581163880b:create

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

