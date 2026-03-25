-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464013829 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\ops_sync_queue.sql
-- sqlcl_snapshot src/database/dev_schema/tables/ops_sync_queue.sql:null:df04288a48e51d3f7ba1029bad830490f1987f7c:create

create table ops_sync_queue (
    queue_id      number generated always as identity not null enable,
    order_item_id varchar2(50 byte),
    retry_count   number default 0,
    last_error    varchar2(4000 byte),
    next_run_at   date default sysdate,
    status        varchar2(20 byte) default 'PENDING',
    created_at    date default sysdate,
    updated_at    date
);

create unique index pk_ops_sync_queue on
    ops_sync_queue (
        queue_id
    );

alter table ops_sync_queue
    add constraint pk_ops_sync_queue primary key ( queue_id )
        using index pk_ops_sync_queue enable;

