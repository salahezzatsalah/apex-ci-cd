-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464048510 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\airports_biu.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/airports_biu.sql:null:57b4a2707ebf982886d7a017436a85fb9289dd33:create

create or replace editionable trigger airports_biu before
    insert or update on airports
    for each row
declare
    v_user varchar2(100);
begin
    -- Get APEX user ID for audit (string)
    v_user := sys_context('APEX$SESSION', 'APP_USER_ID');
    if inserting then
        if :new.airport_id is null then
            :new.airport_id := 'AP-'
                               || lpad(seq_airports.nextval, 6, '0');
        end if;

        :new.created := sysdate;
        :new.created_by := v_user;
    end if;

    if updating then
        :new.updated := sysdate;
        :new.updated_by := v_user;
    end if;

end;
/

alter trigger airports_biu enable;

