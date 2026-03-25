-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463942732 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\currency_rates.sql
-- sqlcl_snapshot src/database/dev_schema/tables/currency_rates.sql:null:42ea819b05657ccc56e2985fe5b41bc2bab2d7f1:create

create table currency_rates (
    rate_id       number generated always as identity not null enable,
    currency_code varchar2(10 byte),
    exchange_rate number(14, 4),
    source        varchar2(100 byte),
    notes         varchar2(500 byte),
    created_by    varchar2(100 byte),
    updated_by    varchar2(100 byte),
    created       timestamp(6) with time zone,
    updated       timestamp(6) with time zone,
    rate_date     timestamp(6) with time zone
);

alter table currency_rates add primary key ( rate_id )
    using index enable;

