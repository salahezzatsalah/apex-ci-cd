-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464016938 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\otp_logs.sql
-- sqlcl_snapshot src/database/dev_schema/tables/otp_logs.sql:null:f4ae27c305971eab7f66d0227c254dca98801ae3:create

create table otp_logs (
    otp_id     varchar2(32 byte),
    user_id    varchar2(32 byte),
    otp_code   varchar2(10 byte),
    purpose    varchar2(30 byte),
    is_used    char(1 byte) default 'N',
    created_at timestamp(6),
    expires_at timestamp(6) with time zone
);

