create or replace editionable trigger trg_notify_driver_on_transaction_entry after
    insert on transaction_entries
    for each row
declare
    v_owner_type   accounts.owner_type%type;
    v_owner_id     accounts.owner_id%type;
    v_account_name accounts.account_name%type;
    v_amount       number;
    v_currency     varchar2(10);
    v_tx_type      varchar2(20);
    v_title        varchar2(255);
    v_body         varchar2(1000);
begin
    -- Fetch account info
    select
        owner_type,
        owner_id,
        account_name
    into
        v_owner_type,
        v_owner_id,
        v_account_name
    from
        accounts
    where
        account_id = :new.account_id;

    -- Only for driver accounts
    if
        v_owner_type = 'Driver'
        and v_owner_id is not null
    then
        v_amount := nvl(:new.debit_amount,
                        :new.credit_amount);
        v_currency := :new.currency_code;
        v_tx_type := :new.transaction_type;
        v_title := 'تم تسجيل حركة مالية على حسابك';
        v_body := 'حصلت عملية '
                  ||
            case v_tx_type
                when 'DEBIT'  then
                    'خصم'
                when 'CREDIT' then
                    'إيداع'
                else
                    'مالية'
            end
                  || ' بقيمة '
                  || to_char(v_amount, 'FM999G999D00')
                  || ' '
                  || v_currency
                  || ' في حساب "'
                  || v_account_name
                  || '".';

        -- Send the notification
        send_user_notification(
            p_notif_type     => 'TRANSACTION',
            p_event_ref_id   => :new.entry_id,
            p_title          => v_title,
            p_body           => v_body,
            p_user_type      => 'DRIVER',
            p_user_id        => v_owner_id,
            p_app_id         => 134,
            p_page_id        => 6008,
            p_target_item_id => :new.account_id,  -- Passes the account
            p_target_url     => null,
            p_channel        => 'APP',
            p_created_by     => nvl(:new.created_by,
                                user)
        );

    end if;

exception
    when no_data_found then
        null;  -- If no matching account, do nothing
    when others then
        null;         -- Silently ignore other errors (optional: log)
end;
/

alter trigger trg_notify_driver_on_transaction_entry enable;


-- sqlcl_snapshot {"hash":"f6d6fab749bb89af12d399559be9c6603c696ced","type":"TRIGGER","name":"TRG_NOTIFY_DRIVER_ON_TRANSACTION_ENTRY","schemaName":"WKSP_ELWAGHA50","sxml":""}