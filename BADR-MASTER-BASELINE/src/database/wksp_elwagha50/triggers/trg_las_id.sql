create or replace editionable trigger trg_las_id before
    insert on limo_add_services
    for each row
begin
    if :new.add_service_id is null then
        :new.add_service_id := 'ADDSVC-'
                               || to_char(seq_limo_add_service.nextval, 'FM000000');
    end if;
end;
/

alter trigger trg_las_id enable;


-- sqlcl_snapshot {"hash":"93f403b0e42946da3d65c6d074d4f923da262b78","type":"TRIGGER","name":"TRG_LAS_ID","schemaName":"WKSP_ELWAGHA50","sxml":""}