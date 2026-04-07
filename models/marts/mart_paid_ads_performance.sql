-- mart_paid_ads_performance.sql
-- Unified cross-channel paid ads performance
--
-- Grain:   one row per platform × campaign × ad_group × date
-- Sources: stg_facebook_ads, stg_google_ads, stg_tiktok_ads
--
-- Design decision: all derived metrics (CTR, CPA, ROAS, VTR, VCR) are computed here at the mart layer — not in the BI tool — to ensure a single definition is used across all dashboards and reports.
-- SAFE_DIVIDE is used throughout to avoid divide-by-zero errors.

WITH unioned AS (
  SELECT * FROM `marketing-test-task.marketing_assignment.stg_facebook_ads`
  UNION ALL
  SELECT * FROM `marketing-test-task.marketing_assignment.stg_google_ads`
  UNION ALL
  SELECT * FROM `marketing-test-task.marketing_assignment.stg_tiktok_ads`
)

SELECT
  -- Dimensions
  date,
  platform,
  campaign_id,
  campaign_name,
  ad_group_id,
  ad_group_name,

  -- Base metrics
  impressions,
  clicks,
  cost,
  conversions,
  conversion_value,
  video_views,
  video_completions,
  reach,
  frequency,
  engagement_rate,
  likes,
  shares,
  comments,

  -- Derived metrics
  SAFE_DIVIDE(clicks, impressions)            AS ctr,   -- click-through rate
  SAFE_DIVIDE(cost, clicks)                   AS cpc,   -- cost per click
  SAFE_DIVIDE(cost, impressions) * 1000       AS cpm,   -- cost per 1000 impressions
  SAFE_DIVIDE(cost, conversions)              AS cpa,   -- cost per acquisition
  SAFE_DIVIDE(conversion_value, cost)         AS roas,  -- return on ad spend (Google only)
  SAFE_DIVIDE(video_views, impressions)       AS vtr,   -- view-through rate (Facebook + TikTok)
  SAFE_DIVIDE(video_completions, video_views) AS vcr    -- video completion rate (TikTok only)

FROM unioned
