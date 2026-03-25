-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463824517 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_limo_return_parent.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_limo_return_parent.sql:null:f8191a83c559a1dc37e10e18998ad65003420907:create

create index ix_limo_return_parent on
    sublevel_limo_res (
        parent_sub_res_id
    );

