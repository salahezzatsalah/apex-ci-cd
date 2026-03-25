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


-- sqlcl_snapshot {"hash":"4da1703ebf0b2bd99fdc7914d6e55b8f7ae02ee7","type":"TRIGGER","name":"AIRPORTS_BIU","schemaName":"DEV_SCHEMA","sxml":""}