-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463825887 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_lpa_product.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_lpa_product.sql:null:01c919b28a095a82d3c7d6205e9e19d7ceead075:create

create index ix_lpa_product on
    limo_product_assignments (
        product_id
    );

