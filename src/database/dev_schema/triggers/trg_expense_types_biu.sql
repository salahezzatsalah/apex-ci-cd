create or replace editionable trigger trg_expense_types_biu before
    insert or update on expense_types
    for each row
begin
    -- Assign ID from sequence if not provided
    if
        inserting
        and :new.id is null
    then
        select
            expense_types_seq.nextval
        into :new.id
        from
            dual;

    end if;

    -- Default IS_ACTIVE to 'Y' if not provided
    if
        inserting
        and :new.is_active is null
    then
        :new.is_active := 'Y';
    end if;

    -- Set created fields on insert
    if inserting then
        :new.created_at := nvl(:new.created_at,
                               sysdate);
        :new.created_by := nvl(:new.created_by,
                               nvl(
                                       v('APP_USER_ID'),
                                       user
                                   ));

    end if;

    -- Always update modified fields on update
    if updating then
        :new.updated_at := sysdate;
        :new.updated_by := nvl(
            v('APP_USER_ID'),
            user
        );
    end if;

end;
/

alter trigger trg_expense_types_biu enable;


-- sqlcl_snapshot {"hash":"b05ab9c13a940e32e07cadb2fbb4a08698db9227","type":"TRIGGER","name":"TRG_EXPENSE_TYPES_BIU","schemaName":"DEV_SCHEMA","sxml":""}