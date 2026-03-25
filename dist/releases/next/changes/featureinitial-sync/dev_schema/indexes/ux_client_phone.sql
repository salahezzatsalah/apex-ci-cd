-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463838704 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_client_phone.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_client_phone.sql:null:22fae04180a89ea6df30c20c4e94c42c03f7d0dd:create

create unique index ux_client_phone on
    client_contacts (
        case
            contact_type
            when 'PHONE' then
                    contact_value
        end
    );

