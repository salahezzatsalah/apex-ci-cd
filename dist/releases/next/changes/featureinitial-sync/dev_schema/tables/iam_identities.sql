-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463960879 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\iam_identities.sql
-- sqlcl_snapshot src/database/dev_schema/tables/iam_identities.sql:null:c8ee79a5e6c47dd368786fc0e5a9c7057508091f:create

create table iam_identities (
    identity_id   varchar2(32 byte) default lower(rawtohex(sys_guid())),
    tenant_id     varchar2(32 byte),
    identity_type varchar2(30 byte),
    first_name    varchar2(150 byte),
    last_name     varchar2(150 byte),
    full_name     varchar2(300 byte),
    national_id   varchar2(50 byte),
    passport_no   varchar2(50 byte),
    email         varchar2(255 byte),
    phone_number  varchar2(50 byte),
    date_of_birth date,
    gender        varchar2(20 byte),
    status        varchar2(20 byte) default 'ACTIVE',
    is_active_yn  varchar2(1 byte) default 'Y',
    created       timestamp(6) with time zone default systimestamp,
    updated       timestamp(6) with time zone,
    party_id      varchar2(32 byte)
);

alter table iam_identities add primary key ( identity_id )
    using index enable;

