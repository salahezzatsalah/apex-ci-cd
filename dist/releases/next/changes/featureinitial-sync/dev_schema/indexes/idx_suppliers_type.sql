-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463818194 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_suppliers_type.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_suppliers_type.sql:null:9eed0b28d4482183467c690803e6d8022d8f16a5:create

create index idx_suppliers_type on
    suppliers (
        supplier_type_id
    );

