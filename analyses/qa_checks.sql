-- qa_checks.sql
-- Manual QA checks for mart_paid_ads_performance
-- Run these in BigQuery after each model refresh to validate data quality

-- -----------------------------------------------------------------------
-- 1. Row counts per platform
--    Expected: 110 rows each (30 days × ~3-4 campaigns, deduplicated by grain)
-- -----------------------------------------------------------------------
SELECT
  platform,
  COUNT(*)              AS total_rows,
  COUNT(DISTINCT date)  AS days_covered,
  COUNT(DISTINCT campaign_id) AS campaigns
FROM `marketing-test-task.marketing_assignment.mart_paid_ads_performance`
GROUP BY 1
ORDER BY 1;


-- -----------------------------------------------------------------------
-- 2. Date coverage — check for gaps and overall range
--    Expected: 2024-01-01 to 2024-01-30, no gaps per platform
-- -----------------------------------------------------------------------
SELECT
  platform,
  MIN(date)             AS first_day,
  MAX(date)             AS last_day,
  COUNT(DISTINCT date)  AS days_present,
  DATE_DIFF(MAX(date), MIN(date), DAY) + 1 AS days_expected
FROM `marketing-test-task.marketing_assignment.mart_paid_ads_performance`
GROUP BY 1
ORDER BY 1;


-- -----------------------------------------------------------------------
-- 3. No negative spend or impressions
--    Expected: 0 rows
-- -----------------------------------------------------------------------
SELECT
  platform,
  campaign_name,
  date,
  cost,
  impressions
FROM `marketing-test-task.marketing_assignment.mart_paid_ads_performance`
WHERE cost < 0
   OR impressions < 0;


-- -----------------------------------------------------------------------
-- 4. CTR sanity check — must be between 0 and 1
--    Expected: 0 rows
-- -----------------------------------------------------------------------
SELECT
  platform,
  campaign_name,
  date,
  clicks,
  impressions,
  ctr
FROM `marketing-test-task.marketing_assignment.mart_paid_ads_performance`
WHERE ctr > 1
   OR ctr < 0;


-- -----------------------------------------------------------------------
-- 5. Conversions without spend (suspicious)
--    Expected: 0 rows — free conversions usually indicate a data issue
-- -----------------------------------------------------------------------
SELECT
  platform,
  campaign_name,
  date,
  conversions,
  cost
FROM `marketing-test-task.marketing_assignment.mart_paid_ads_performance`
WHERE conversions > 0
  AND cost = 0;


-- -----------------------------------------------------------------------
-- 6. Platform column values
--    Expected: only 'facebook', 'google', 'tiktok'
-- -----------------------------------------------------------------------
SELECT DISTINCT platform
FROM `marketing-test-task.marketing_assignment.mart_paid_ads_performance`
ORDER BY 1;


-- -----------------------------------------------------------------------
-- 7. Total spend cross-check against source tables
--    Compare mart totals vs raw source totals — must match exactly
-- -----------------------------------------------------------------------
SELECT 'mart'     AS source, platform, ROUND(SUM(cost), 2) AS total_spend
FROM `marketing-test-task.marketing_assignment.mart_paid_ads_performance`
GROUP BY 1, 2

UNION ALL

SELECT 'raw_facebook' AS source, 'facebook' AS platform, ROUND(SUM(spend), 2)
FROM `marketing-test-task.marketing_assignment.facebook_ads`

UNION ALL

SELECT 'raw_google' AS source, 'google' AS platform, ROUND(SUM(cost), 2)
FROM `marketing-test-task.marketing_assignment.google_ads`

UNION ALL

SELECT 'raw_tiktok' AS source, 'tiktok' AS platform, ROUND(SUM(cost), 2)
FROM `marketing-test-task.marketing_assignment.tiktok_ads`

ORDER BY platform, source;


-- -----------------------------------------------------------------------
-- 8. NULL check — columns that must never be NULL across all platforms
-- -----------------------------------------------------------------------
SELECT
  platform,
  COUNTIF(date IS NULL)          AS null_date,
  COUNTIF(campaign_id IS NULL)   AS null_campaign_id,
  COUNTIF(impressions IS NULL)   AS null_impressions,
  COUNTIF(clicks IS NULL)        AS null_clicks,
  COUNTIF(cost IS NULL)          AS null_cost
FROM `marketing-test-task.marketing_assignment.mart_paid_ads_performance`
GROUP BY 1
ORDER BY 1;
