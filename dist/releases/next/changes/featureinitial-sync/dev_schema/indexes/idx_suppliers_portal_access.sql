-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463817757 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_suppliers_portal_access.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_suppliers_portal_access.sql:null:1e67f8bea91481b332ed0d6ca1faa61838077958:create

create index idx_suppliers_portal_access on
    suppliers (
        has_portal_access
    );

