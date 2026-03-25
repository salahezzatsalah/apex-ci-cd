create or replace force editionable view v_user_notifications (
    notif_id,
    notif_type,
    event_ref_id,
    title,
    body,
    user_type,
    user_id,
    status,
    app_id,
    page_id,
    target_item_id,
    target_url,
    channel,
    sent_at,
    read_at,
    created,
    created_by,
    target_url_virtual
) as
    select
        notif_id,
        notif_type,
        event_ref_id,
        title,
        body,
        user_type,
        user_id,
        status,
        app_id,
        page_id,
        target_item_id,
        target_url,
        channel,
        sent_at,
        read_at,
        created,
        created_by,
    -- Build the correct virtual URL
        coalesce(target_url,
                 case
                     when app_id is not null
                          and page_id is not null
                          and target_item_id is not null then
                         'f?p='
                         || app_id
                         || ':'
                         || page_id
                         || '::'
                         || ':NO::'
                         ||
                         case
                                 when page_id = 6001 then
                                     'P6001_PRODUCT_ID'
                                 when page_id = 7001 then
                                     'P7001_EXPENSE_ID'
                                 when page_id = 7201 then
                                     'P7201_COLLECTION_ID'
                -- Add more page/item logic here
                                 else
                                     'P'
                                     || page_id
                                     || '_ID' -- Fallback generic pattern
                         end
                         || ':'
                         || target_item_id
                     when app_id is not null
                          and page_id is not null then
                         'f?p='
                         || app_id
                         || ':'
                         || page_id
                     else
                         null
                 end
        ) as target_url_virtual
    from
        user_notifications;


-- sqlcl_snapshot {"hash":"5b82334e6168a95984238bfe1b405cdc9572ca84","type":"VIEW","name":"V_USER_NOTIFICATIONS","schemaName":"WKSP_ELWAGHA50","sxml":""}