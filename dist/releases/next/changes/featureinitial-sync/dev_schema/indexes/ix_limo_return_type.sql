-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463825004 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_limo_return_type.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_limo_return_type.sql:null:3ade968442667a505f649bcc3c4638322da1a4b4:create

create index ix_limo_return_type on
    sublevel_limo_res (
        return_type,
        return_status
    );

