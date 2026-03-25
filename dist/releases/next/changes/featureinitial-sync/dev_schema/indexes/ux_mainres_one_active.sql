-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463848494 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_mainres_one_active.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_mainres_one_active.sql:null:0321a186cef76c1158b7da09d5b2f1a2ff484afe:create

create unique index ux_mainres_one_active on
    main_reservations (
        customer_id,
        case
            status
            when 'ACTIVE' then
                'ACTIVE'
        end
    );

