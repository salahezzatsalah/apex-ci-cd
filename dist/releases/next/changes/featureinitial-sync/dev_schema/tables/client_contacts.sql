-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463935834 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\client_contacts.sql
-- sqlcl_snapshot src/database/dev_schema/tables/client_contacts.sql:null:0c1f1db9fa8fd41dd0f7bf5b65efebb0f771da57:create

create table client_contacts (
    contact_id    number,
    client_id     varchar2(36 byte),
    contact_type  varchar2(20 byte),
    contact_value varchar2(150 byte),
    is_primary    char(1 byte) default 'N',
    verified      char(1 byte) default 'N',
    created_at    date default sysdate
);

alter table client_contacts add primary key ( contact_id )
    using index enable;

