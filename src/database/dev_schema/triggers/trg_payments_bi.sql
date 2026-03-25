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


-- sqlcl_snapshot {"hash":"d20bf12c93378a49eb98ae70126af038905e229e","type":"TRIGGER","name":"TRG_PAYMENTS_BI","schemaName":"DEV_SCHEMA","sxml":""}