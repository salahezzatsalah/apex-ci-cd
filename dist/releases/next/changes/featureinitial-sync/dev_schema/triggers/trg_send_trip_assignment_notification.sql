-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464113727 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_send_trip_assignment_notification.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_send_trip_assignment_notification.sql:null:4c272f1e8be470dc35ff3d7e6f3a4d92436ce720:create

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

