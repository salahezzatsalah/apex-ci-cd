create or replace editionable trigger trg_send_trip_assignment_notification after
    insert on limo_product_assignments
    for each row
begin
    if
        :new.assignment_type = 'INSOURCE'
        and :new.driver_id is not null
    then
        send_user_notification(
            p_notif_type     => 'TRIP_ASSIGNED',
            p_event_ref_id   => :new.assignment_id,
            p_title          => 'تم تعيين رحلة جديدة',
            p_body           => 'تم تعيينك لرحلة جديدة. اضغط لعرض التفاصيل.',
            p_user_type      => 'DRIVER',
            p_user_id        => :new.driver_id,
            p_app_id         => 134,
            p_page_id        => 6001,
            p_target_item_id => :new.product_id,   -- <-- Now matched
            p_target_url     => null,
            p_channel        => 'APP',
            p_created_by     => nvl(:new.created_by,
                                user)
        );

    end if;
end;
/

alter trigger trg_send_trip_assignment_notification enable;


-- sqlcl_snapshot {"hash":"d4014980592f81234a9c1d5d161b2feb7eb8fccb","type":"TRIGGER","name":"TRG_SEND_TRIP_ASSIGNMENT_NOTIFICATION","schemaName":"WKSP_ELWAGHA50","sxml":""}