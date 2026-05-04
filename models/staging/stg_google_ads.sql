-- stg_google_ads.sql
-- Staging model for Google Ads raw data
-- Normalizes field names and types to match the unified mart schema
-- Source: marketing-test-task.marketing_assignment.google_ads

SELECT
  -- Dimensions
  date,
  'google'                           AS platform,
  campaign_id,
  campaign_name,
  ad_group_id,
  ad_group_name,

  -- Base metrics
  impressions,
  clicks,
  cost,
  conversions,
  conversion_value,                  -- only platform with revenue data
  CAST(NULL AS INT64)                AS video_views,       -- not available on Google Search/Shopping
  CAST(NULL AS INT64)                AS video_completions, -- not available on Google Search/Shopping
  CAST(NULL AS INT64)                AS reach,             -- not available on Google
  CAST(NULL AS FLOAT64)              AS frequency,         -- not available on Google
  CAST(NULL AS FLOAT64)              AS engagement_rate,   -- not available on Google

  -- Engagement
  CAST(NULL AS INT64)                AS likes,
  CAST(NULL AS INT64)                AS shares,
  CAST(NULL AS INT64)                AS comments

FROM {{ source('raw', 'google_ads') }}
