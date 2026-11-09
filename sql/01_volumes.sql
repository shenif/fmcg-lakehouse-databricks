-- Unity Catalog Volumes that replace the video's S3 bucket.
-- Run after 1_setup/setup_catalog has created the fmcg catalog and schemas.

CREATE VOLUME IF NOT EXISTS fmcg.bronze.child_raw;               -- child company raw CSVs
CREATE VOLUME IF NOT EXISTS fmcg.gold.parent_full_load;          -- parent company clean CSVs
CREATE VOLUME IF NOT EXISTS fmcg.gold.parent_incremental_data;   -- parent December increment
