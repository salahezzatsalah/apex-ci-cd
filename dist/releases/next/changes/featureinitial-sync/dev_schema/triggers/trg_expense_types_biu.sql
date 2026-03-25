-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464094073 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_expense_types_biu.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_expense_types_biu.sql:null:c7cbc76efe9e93d5ab0a6471a50c067837e10f18:create

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

