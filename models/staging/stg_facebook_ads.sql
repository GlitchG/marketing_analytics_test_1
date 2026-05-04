-- stg_facebook_ads.sql
-- Staging model for Facebook Ads raw data
-- Normalizes field names and types to match the unified mart schema
-- Source: marketing-test-task.marketing_assignment.facebook_ads

SELECT
  -- Dimensions
  date,
  'facebook'                         AS platform,
  campaign_id,
  campaign_name,
  ad_set_id                          AS ad_group_id,   -- renamed to unified key
  ad_set_name                        AS ad_group_name,

  -- Base metrics
  impressions,
  clicks,
  spend                              AS cost,           -- renamed to unified field
  conversions,
  CAST(NULL AS FLOAT64)              AS conversion_value,  -- not available on Facebook
  video_views,
  CAST(NULL AS INT64)                AS video_completions, -- not available on Facebook
  reach,
  frequency,
  engagement_rate,

  -- Engagement (Facebook-specific)
  CAST(NULL AS INT64)                AS likes,
  CAST(NULL AS INT64)                AS shares,
  CAST(NULL AS INT64)                AS comments

FROM {{ source('raw', 'facebook_ads') }}
