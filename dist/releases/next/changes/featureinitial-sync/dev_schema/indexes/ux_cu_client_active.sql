-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463839219 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_cu_client_active.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_cu_client_active.sql:null:2fefabd7548d749ad1d06c45cf4f00e77d4f4c36:create

create unique index ux_cu_client_active on
    customer_users (
        case
            status
            when 'ACTIVE' then
                    client_id
        end
    );

