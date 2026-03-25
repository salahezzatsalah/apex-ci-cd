-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463996283 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_res_accounting.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_res_accounting.sql:null:d6832064418484d072de48ec376f6db370630fe6:create

create table limo_res_accounting (
    res_acc_id              varchar2(30 byte),
    sub_res_id              varchar2(30 byte),
    trips_count             number,
    total_invoice_egp       number(12, 2),
    total_invoice_curr      number(12, 2),
    total_services_egp      number(12, 2),
    total_expenses_egp      number(12, 2),
    total_revenue_after_exp number(12, 2),
    total_paid_egp          number(12, 2),
    total_paid_curr         number(12, 2),
    total_outstanding_egp   number(12, 2),
    total_outstanding_curr  number(12, 2),
    total_driver_payout_egp number(12, 2),
    total_office_net_egp    number(12, 2),
    total_office_net_curr   number(12, 2),
    last_calc_at            timestamp(6) with time zone,
    created                 timestamp(6) default systimestamp,
    created_by              varchar2(100 byte),
    updated                 timestamp(6),
    updated_by              varchar2(100 byte)
);

create unique index uk_lra_sub on
    limo_res_accounting (
        sub_res_id
    );

alter table limo_res_accounting
    add constraint uk_lra_sub unique ( sub_res_id )
        using index uk_lra_sub enable;

alter table limo_res_accounting add primary key ( res_acc_id )
    using index enable;

