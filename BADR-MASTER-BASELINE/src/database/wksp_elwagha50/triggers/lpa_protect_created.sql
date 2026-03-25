create or replace editionable trigger lpa_protect_created before
    update on limo_product_assignments
    for each row
begin
    if :new.created <> :old.created
    or :new.created_by <> :old.created_by then
        raise_application_error(-20001, 'CREATED fields cannot be modified.');
    end if;
end;
/

alter trigger lpa_protect_created enable;


-- sqlcl_snapshot {"hash":"c7472529e3d30b7b420c92aca022ba0825a7041b","type":"TRIGGER","name":"LPA_PROTECT_CREATED","schemaName":"WKSP_ELWAGHA50","sxml":""}