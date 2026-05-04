-- stg_tiktok_ads.sql
-- Staging model for TikTok Ads raw data
-- Normalizes field names and types to match the unified mart schema
-- Source: marketing-test-task.marketing_assignment.tiktok_ads

SELECT
  -- Dimensions
  date,
  'tiktok'                           AS platform,
  campaign_id,
  campaign_name,
  adgroup_id                         AS ad_group_id,   -- renamed to unified key
  adgroup_name                       AS ad_group_name,

  -- Base metrics
  impressions,
  clicks,
  cost,
  conversions,
  CAST(NULL AS FLOAT64)              AS conversion_value,  -- not available on TikTok
  video_views,
  video_watch_100                    AS video_completions, -- renamed to unified field
  CAST(NULL AS INT64)                AS reach,             -- not available on TikTok
  CAST(NULL AS FLOAT64)              AS frequency,         -- not available on TikTok
  CAST(NULL AS FLOAT64)              AS engagement_rate,   -- not available on TikTok

  -- Engagement (TikTok-specific)
  likes,
  shares,
  comments

FROM {{ source('raw', 'tiktok_ads') }}
