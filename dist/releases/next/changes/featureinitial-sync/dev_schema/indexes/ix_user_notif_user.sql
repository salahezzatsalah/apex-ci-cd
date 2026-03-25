-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463834456 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_user_notif_user.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_user_notif_user.sql:null:3bc3aa819455af0bcba0995988e21ccafd6f312a:create

create index ix_user_notif_user on
    user_notifications (
        user_type,
        user_id,
        status
    );

