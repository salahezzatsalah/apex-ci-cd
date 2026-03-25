-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464077142 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\sp_countries_biu.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/sp_countries_biu.sql:null:cb5bd883f70e295b4d90506f996e84b5e7539661:create

create or replace editionable trigger sp_countries_biu before
    insert or update on sp_countries
    for each row
begin
    if inserting then
        :new.created := localtimestamp;
        :new.created_by := nvl(wwv_flow.g_user, user);
        :new.updated := localtimestamp;
        :new.updated_by := nvl(wwv_flow.g_user, user);
    end if;

    if inserting
    or updating then
        :new.updated := localtimestamp;
        :new.updated_by := nvl(wwv_flow.g_user, user);
    end if;

    if :new.display_yn is null then
        :new.display_yn := 'Y';
    end if;

    if :new.quick_pick_yn is null then
        :new.quick_pick_yn := 'N';
    end if;

end sp_countries_biu;
/

alter trigger sp_countries_biu enable;

