-- Load the parent company's already-clean data straight into gold.
-- Types are explicit so the child MERGEs line up later.

USE CATALOG fmcg;

CREATE TABLE IF NOT EXISTS gold.dim_customers   (customer_code BIGINT, customer STRING, market STRING, platform STRING, channel STRING);
CREATE TABLE IF NOT EXISTS gold.dim_products    (product_code STRING, division STRING, category STRING, product STRING, variant STRING);
CREATE TABLE IF NOT EXISTS gold.dim_gross_price (product_code STRING, price_inr DOUBLE, year STRING);
CREATE TABLE IF NOT EXISTS gold.fact_orders     (date DATE, product_code STRING, customer_code BIGINT, sold_quantity BIGINT);

COPY INTO gold.dim_customers FROM (
  SELECT CAST(customer_code AS BIGINT), customer, market, platform, channel
  FROM '/Volumes/fmcg/gold/parent_full_load/dim_customers.csv')
FILEFORMAT = CSV FORMAT_OPTIONS ('header' = 'true');

COPY INTO gold.dim_products FROM (
  SELECT product_code, division, category, product, variant
  FROM '/Volumes/fmcg/gold/parent_full_load/dim_products.csv')
FILEFORMAT = CSV FORMAT_OPTIONS ('header' = 'true');

COPY INTO gold.dim_gross_price FROM (
  SELECT product_code, CAST(price_inr AS DOUBLE), CAST(year AS STRING)
  FROM '/Volumes/fmcg/gold/parent_full_load/dim_gross_price.csv')
FILEFORMAT = CSV FORMAT_OPTIONS ('header' = 'true');

COPY INTO gold.fact_orders FROM (
  SELECT CAST(date AS DATE), product_code, CAST(customer_code AS BIGINT), CAST(sold_quantity AS BIGINT)
  FROM '/Volumes/fmcg/gold/parent_full_load/fact_orders.csv')
FILEFORMAT = CSV FORMAT_OPTIONS ('header' = 'true');

-- Validation (expected: 18, 397, 794, 93055)
SELECT 'dim_customers' AS tbl, COUNT(*) FROM gold.dim_customers
UNION ALL SELECT 'dim_products', COUNT(*) FROM gold.dim_products
UNION ALL SELECT 'dim_gross_price', COUNT(*) FROM gold.dim_gross_price
UNION ALL SELECT 'fact_orders', COUNT(*) FROM gold.fact_orders;
