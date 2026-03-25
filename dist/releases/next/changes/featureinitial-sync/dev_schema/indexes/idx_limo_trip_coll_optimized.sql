-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463816535 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_limo_trip_coll_optimized.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_limo_trip_coll_optimized.sql:null:fbbbac507ee501b1aeb1232ca97d6fa444b0d973:create

create index idx_limo_trip_coll_optimized on
    limo_trip_collections (
        collected_by_type,
        collected_by_id,
        currency,
        trip_id
    );

