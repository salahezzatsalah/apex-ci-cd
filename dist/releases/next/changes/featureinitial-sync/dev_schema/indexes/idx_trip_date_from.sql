-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463818995 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_trip_date_from.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_trip_date_from.sql:null:82f9893ead11f980386c24c0c8bb051abe3c148d:create

create index idx_trip_date_from on
    limo_reservations (
        from_date
    );

