-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463817349 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_suppliers_email.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_suppliers_email.sql:null:46b0cfe35e2125179659caba497dea489a93e61b:create

create index idx_suppliers_email on
    suppliers (
        email
    );

