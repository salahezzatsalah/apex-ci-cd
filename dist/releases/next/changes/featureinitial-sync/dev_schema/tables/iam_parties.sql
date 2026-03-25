-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463964462 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\iam_parties.sql
-- sqlcl_snapshot src/database/dev_schema/tables/iam_parties.sql:null:9c05652b669ae0782caa17308caa7f73ecc0fc38:create

create table iam_parties (
    party_id   varchar2(32 byte) default lower(rawtohex(sys_guid())),
    tenant_id  varchar2(32 byte),
    party_type varchar2(20 byte),
    status     varchar2(20 byte) default 'ACTIVE',
    created    timestamp(6) with time zone default systimestamp,
    updated    timestamp(6) with time zone
);

alter table iam_parties add primary key ( party_id )
    using index enable;

