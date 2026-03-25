-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463815401 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_limo_trip_coll_driver_curr.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_limo_trip_coll_driver_curr.sql:null:68653773cb1845123ba3b351c6aa9baa50050f19:create

create index idx_limo_trip_coll_driver_curr on
    limo_trip_collections (
        collected_by_type,
        collected_by_id,
        currency
    );

