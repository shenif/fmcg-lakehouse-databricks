-- Parent company December 2025 increment.
-- COPY INTO tracks loaded files, so re-running does not duplicate rows.

COPY INTO fmcg.gold.fact_orders
FROM (
  SELECT CAST(date AS DATE) AS date, product_code,
         CAST(customer_code AS BIGINT) AS customer_code,
         CAST(sold_quantity AS BIGINT) AS sold_quantity
  FROM '/Volumes/fmcg/gold/parent_incremental_data/fact_orders.csv')
FILEFORMAT = CSV
FORMAT_OPTIONS ('header' = 'true');

-- Validation: parent alone = 4,485; after the child incremental notebook = 5,097
SELECT COUNT(*) FROM fmcg.gold.fact_orders WHERE date = '2025-12-01';
