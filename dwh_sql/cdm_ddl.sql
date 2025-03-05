CREATE SCHEMA cdm;

CREATE  MATERIALIZED VIEW cdm.stocks_stats_monthly AS
SELECT  t2. ticker AS stock_name,
        DATE_TRUNC('MONTH', date)::DATE AS year_month,
        ROUND(AVG(open),3) AS avg_open,
        ROUND(AVG(high),3) AS avg_high,
        ROUND(AVG(low),3) AS avg_low,
        ROUND(AVG(close),3) AS avg_close,
        ROUND(AVG(volume),3) AS avg_volume
FROM dds.stock_history t1
    JOIN dds.stock_info t2 ON t2.id = t1.ticker_id
GROUP BY 1,2
ORDER BY 1, 2 DESC;

CREATE MATERIALIZED VIEW cdm.stocks_volatility_monthly AS
SELECT 
    t2.ticker AS stock_name,
    DATE_TRUNC('MONTH', date)::DATE AS year_month,
    ROUND(MAX(high) - MIN(low), 3) AS volatility_range,
    ROUND(AVG(close), 3) AS avg_close
FROM dds.stock_history t1
    JOIN dds.stock_info t2 ON t2.id = t1.ticker_id
GROUP BY 1, 2
ORDER BY 1, 2 DESC;

CREATE MATERIALIZED VIEW cdm.dividends_yearly AS
SELECT 
    t2.ticker AS stock_name,
    DATE_TRUNC('YEAR', t1.date)::DATE AS year,
    COUNT(*) AS dividend_count,
    ROUND(SUM(t1.dividends), 2) AS total_dividends
FROM dds.stock_dividends_history t1
    JOIN dds.stock_info t2 ON t2.id = t1.ticker_id
GROUP BY 1, 2
ORDER BY 1, 2 DESC;




