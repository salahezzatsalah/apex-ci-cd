-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463947675 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\default_currency.sql
-- sqlcl_snapshot src/database/dev_schema/tables/default_currency.sql:null:94d09659fcd94a1803d5a2a71bcf53a26f298967:create

create table default_currency (
    id            number generated always as identity not null enable,
    currency_code varchar2(10 byte),
    set_by        varchar2(100 byte),
    set_date      timestamp(6) with time zone
);

alter table default_currency add primary key ( id )
    using index enable;

