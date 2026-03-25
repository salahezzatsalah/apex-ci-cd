-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463986505 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_car_types.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_car_types.sql:null:250ef1a56b03b36d3a1b5fb8f49db6f5b355b562:create

create table limo_car_types (
    car_type_id        varchar2(255 byte),
    car_type_name      varchar2(255 byte),
    category           varchar2(100 byte),
    seats              number,
    status             varchar2(20 byte) default 'Active',
    created_by         varchar2(100 byte),
    updated_by         varchar2(100 byte),
    description        varchar2(1000 byte),
    created            timestamp(6) with time zone,
    updated            timestamp(6) with time zone,
    photo_url          varchar2(7000 byte),
    model_year         number(4, 0),
    max_passengers     number,
    max_luggage        number,
    personal_driver_yn char(1 byte) default 'Y',
    main_photo_url     varchar2(4000 byte),
    min_km             number default 0
);

alter table limo_car_types add primary key ( car_type_id )
    using index enable;

