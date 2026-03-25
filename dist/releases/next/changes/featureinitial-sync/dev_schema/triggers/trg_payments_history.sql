-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464112048 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_payments_history.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_payments_history.sql:null:102d19a8d703a491aa15d06398d598ab93049f09:create

create or replace editionable trigger trg_payments_history after
    insert or update or delete on payments
    for each row
declare
    v_user           varchar2(255) := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
    v_reservation_id varchar2(30) := coalesce(:new.reservation_id,
                                              :old.reservation_id);
begin
    if v_reservation_id like 'HR-%' then
        if inserting then
            insert into hotel_reservation_history (
                reservation_id,
                attribute_column,
                change_type,
                old_value,
                new_value,
                old_value_clob,
                new_value_clob,
                changed_on,
                changed_by
            ) values ( v_reservation_id,
                       'PAYMENT',
                       'CREATE',
                       null,
                       null,
                       null,
                       'تمت إضافة دفعة ('
                       || :new.payment_amount
                       || ' '
                       || :new.payment_currency
                       || ') عبر '
                       || :new.payment_method
                       ||
                       case
                           when :new.reference_number is not null then
                                   ' - مرجع: ' || :new.reference_number
                           else
                               ''
                       end,
                       systimestamp,
                       v_user );

        elsif updating then
            insert into hotel_reservation_history (
                reservation_id,
                attribute_column,
                change_type,
                old_value,
                new_value,
                old_value_clob,
                new_value_clob,
                changed_on,
                changed_by
            ) values ( v_reservation_id,
                       'PAYMENT',
                       'UPDATE',
                       null,
                       null,
                       'السابق: '
                       || :old.payment_amount
                       || ' '
                       || :old.payment_currency
                       || ' عبر '
                       || :old.payment_method
                       ||
                       case
                           when :old.reference_number is not null then
                                   ' - مرجع: ' || :old.reference_number
                           else
                               ''
                       end,
                       'الجديد: '
                       || :new.payment_amount
                       || ' '
                       || :new.payment_currency
                       || ' عبر '
                       || :new.payment_method
                       ||
                       case
                           when :new.reference_number is not null then
                                   ' - مرجع: ' || :new.reference_number
                           else
                               ''
                       end,
                       systimestamp,
                       v_user );

        elsif deleting then
            insert into hotel_reservation_history (
                reservation_id,
                attribute_column,
                change_type,
                old_value,
                new_value,
                old_value_clob,
                new_value_clob,
                changed_on,
                changed_by
            ) values ( v_reservation_id,
                       'PAYMENT',
                       'DELETE',
                       null,
                       null,
                       'تم حذف دفعة بقيمة '
                       || :old.payment_amount
                       || ' '
                       || :old.payment_currency
                       || ' عبر '
                       || :old.payment_method
                       ||
                       case
                           when :old.reference_number is not null then
                                   ' - مرجع: ' || :old.reference_number
                           else
                               ''
                       end,
                       null,
                       systimestamp,
                       v_user );

        end if;

    end if;
end;
/

alter trigger trg_payments_history enable;

