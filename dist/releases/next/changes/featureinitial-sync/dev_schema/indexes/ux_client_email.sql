-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463838220 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_client_email.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_client_email.sql:null:e7a9ee1e8e7b1f70b03edc8c1440ccd8a2165c69:create

create unique index ux_client_email on
    client_contacts (
        case
            contact_type
            when 'EMAIL' then
                lower(contact_value)
        end
    );

