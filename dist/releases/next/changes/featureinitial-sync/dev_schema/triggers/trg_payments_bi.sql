-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464110354 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_payments_bi.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_payments_bi.sql:null:d363eb486599be1d1b644f1d9d7edb8f91a03348:create

create or replace editionable trigger trg_payments_bi before
    insert on payments
    for each row
begin
    if :new.payment_id is null then
        :new.payment_id := 'PAY-'
                           || to_char(payments_seq.nextval, 'FM000000');
    end if;

    :new.created := systimestamp;
    :new.created_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
    :new.updated := :new.created;
    :new.updated_by := :new.created_by;
end;
/

alter trigger trg_payments_bi enable;

