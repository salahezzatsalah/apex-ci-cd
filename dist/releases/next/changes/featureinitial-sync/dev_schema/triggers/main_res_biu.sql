-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464075522 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\main_res_biu.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/main_res_biu.sql:null:48b90a71f10c4b01f0eeb6d3d1ff060ebe0da861:create

create or replace editionable trigger main_res_biu before
    insert or update on main_reservations
    for each row
begin
    if inserting then
        if :new.main_res_id is null then
            :new.main_res_id := 'MR-'
                                || lpad(seq_main_res_id.nextval, 6, '0');
        end if;

        :new.created := systimestamp;
    end if;

    if updating then
        :new.updated := systimestamp;
    end if;
end;
/

alter trigger main_res_biu enable;

