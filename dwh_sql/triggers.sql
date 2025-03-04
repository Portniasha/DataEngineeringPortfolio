
CREATE OR REPLACE FUNCTION core.write_table_metadata(schema_name text, table_name TEXT, stg_schema TEXT, stg_table text)
RETURNS void AS
$$
DECLARE
    v_cnt bigint;
BEGIN 
    EXECUTE FORMAT('UPDATE core.table_metadata SET is_actual = FALSE WHERE schema_name = ''%s'' and table_name = ''%s'' ;', schema_name, table_name);
    EXECUTE FORMAT('SELECT COUNT(*) FROM %I.%I;', stg_schema, stg_table) INTO v_cnt;
    EXECUTE FORMAT('INSERT INTO core.table_metadata(schema_name, table_name, load_dt, is_actual, source, rows_cnt)
                    VALUES(''%s'',
                           ''%s'',
                           CURRENT_TIMESTAMP,
                           TRUE,
                           ''airflow'',
                           ''%s''
                    );
    ', schema_name, table_name, v_cnt);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION core.write_metadata_dds_ticker()
RETURNS trigger AS
$$
BEGIN
    EXECUTE core.write_table_metadata('dds', 'stock_info', 'stg', 'stock_info');
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION core.write_metadata_dds_ticker_price_history()
RETURNS trigger AS
$$
BEGIN
    EXECUTE core.write_table_metadata('dds', 'stock_history', 'stg', 'stock_history');
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION core.write_metadata_dds_ticker_dividends_history()
RETURNS trigger AS
$$
BEGIN
    EXECUTE core.write_table_metadata('dds', 'stock_dividends_history', 'stg', 'stock_dividends_history');
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION core.write_metadata_dds_ticker_balance_sheet()
RETURNS trigger AS
$$
BEGIN
    EXECUTE core.write_table_metadata('dds', 'stock_balance_sheet', 'stg', 'stock_balance_sheet');
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS trigger_fn_dds_ticker ON dds.stock_info;
CREATE TRIGGER trigger_fn_dds_ticker
    BEFORE INSERT
    ON dds.stock_info
    FOR EACH STATEMENT
    EXECUTE FUNCTION core.write_metadata_dds_ticker();

DROP TRIGGER IF EXISTS trigger_fn_dds_ticker_price_history ON dds.stock_history;
CREATE TRIGGER trigger_fn_dds_ticker_price_history
    BEFORE INSERT
    ON dds.stock_history
    FOR EACH STATEMENT
    EXECUTE FUNCTION core.write_metadata_dds_ticker_price_history();

DROP TRIGGER IF EXISTS trigger_fn_dds_ticker_dividends_history ON dds.stock_dividends_history;
CREATE TRIGGER trigger_fn_dds_ticker_dividends_history
    BEFORE INSERT
    ON dds.stock_dividends_history
    FOR EACH STATEMENT
    EXECUTE FUNCTION core.write_metadata_dds_ticker_dividends_history();

DROP TRIGGER IF EXISTS trigger_fn_dds_ticker_balance_sheet ON dds.stock_balance_sheet;
CREATE TRIGGER trigger_fn_dds_ticker_balance_sheet
    BEFORE INSERT
    ON dds.stock_balance_sheet
    FOR EACH STATEMENT
    EXECUTE FUNCTION core.write_metadata_dds_ticker_balance_sheet();


DROP TRIGGER IF EXISTS partition_trigger_fn_dds_ticker ON dds.stock_history;
CREATE TRIGGER partition_trigger_fn_dds_ticker
    AFTER INSERT
    ON dds.stock_history
    FOR EACH STATEMENT
    EXECUTE FUNCTION core.write_dm_metadata_cdm_stocks_stats_monthly();

DROP TRIGGER IF EXISTS partition_trigger_fn_dds_ticker_balance_sheet ON dds.stock_balance_sheet;
CREATE TRIGGER partition_trigger_fn_dds_ticker_balance_sheet
    BEFORE INSERT
    ON dds.stock_balance_sheet
    FOR EACH STATEMENT
    EXECUTE FUNCTION core.write_metadata_dds_ticker_balance_sheet();

DROP TRIGGER IF EXISTS partition_trigger_fn_dds_ticker_dividends_history ON dds.stock_dividends_history;
CREATE TRIGGER partition_trigger_fn_dds_ticker_dividends_history
    BEFORE INSERT
    ON dds.stock_dividends_history
    FOR EACH STATEMENT
    EXECUTE FUNCTION core.write_metadata_dds_ticker_dividends_history();

DROP TRIGGER IF EXISTS partition_trigger_fn_dds_ticker_price_history ON dds.stock_history;
CREATE TRIGGER partition_trigger_fn_dds_ticker_price_history
    BEFORE INSERT
    ON dds.stock_history
    FOR EACH STATEMENT
    EXECUTE FUNCTION core.write_metadata_dds_ticker_price_history();

