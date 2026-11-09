-- End-to-end checks run after the full pipeline.

SHOW SCHEMAS IN fmcg;
SHOW VOLUMES IN fmcg.bronze;
SHOW VOLUMES IN fmcg.gold;
SHOW TABLES IN fmcg.gold;

SELECT COUNT(*) FROM fmcg.gold.dim_date;          -- 24 month rows
SELECT COUNT(*) FROM fmcg.gold.fact_orders;       -- 101,212 after all loads

SELECT * FROM fmcg.gold.dim_customers WHERE platform = 'Sports Bar';   -- child customers merged in

SELECT COUNT(DISTINCT customer_code) FROM fmcg.gold.vw_fact_orders_enriched;  -- 54

-- Rows with no matching customer (the "null" channel on the dashboard)
SELECT customer_code, COUNT(*) FROM fmcg.gold.vw_fact_orders_enriched
WHERE channel IS NULL GROUP BY customer_code;
