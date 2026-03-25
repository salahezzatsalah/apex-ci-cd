-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463814973 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_limo_coll_trip.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_limo_coll_trip.sql:null:25b1532d9f0634f200bc57204d095bc63ec3fb0a:create

create index idx_limo_coll_trip on
    limo_trip_collections (
        trip_id
    );

