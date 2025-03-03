CREATE SCHEMA core;


CREATE TABLE core.table_metadata(
    id              BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY
    , schema_name   VARCHAR(25)
    , table_name    VARCHAR(64)
    , load_dt       TIMESTAMP
    , is_actual     BOOLEAN
    , "source"      VARCHAR(30)
    , cnt_rows      BIGINT

);

CREATE TABLE core.datamart_metadata(
    id              BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY
    , schema_name   VARCHAR(25)
    , table_name    VARCHAR(64)
    , load_dt       TIMESTAMP
    , cnt_rows      BIGINT
    
);


SELECT * FROM core.datamart_metadata;

