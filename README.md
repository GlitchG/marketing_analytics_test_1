### Marketing Analytics — dbt Project

A small dbt project that lands raw spend data from Facebook, Google, and TikTok ads into clean, analysis-ready marts on BigQuery. Built as a reference for what a paid-ads dbt setup looks like end to end — staging models, schema documentation, tests, CI.

#### Layout

```
models/
  staging/
    stg_facebook_ads.sql       — Cleaned Facebook Ads daily data
    stg_google_ads.sql          — Cleaned Google Ads daily data
    stg_tiktok_ads.sql          — Cleaned TikTok Ads daily data
    schema.yml                  — Column docs + dbt tests
  marts/
    mart_paid_ads_performance.sql   — Unified daily spend / impressions / clicks / conversions across all three platforms
    schema.yml
analyses/
  qa_checks.sql                 — Standalone validation queries
.github/workflows/
  test-sql.yml                  — dbt parse + SQLFluff lint on every push
```

The interesting work is in `mart_paid_ads_performance` — that's where the three platform-specific staging models get reconciled into one schema. Different ad platforms report the same concept (spend, impressions, clicks, conversions) using different field names, granularities, currencies, and date semantics. The mart hides all of that so downstream Looker / Power BI dashboards stay simple.

#### Running it

You need a Google Cloud project with BigQuery enabled (free tier is fine).

```
git clone https://github.com/GlitchG/marketing_analytics_sample_reporting.git
cd marketing_analytics_sample_reporting
pip install dbt-bigquery

# Set up your profile in ~/.dbt/profiles.yml pointing at your GCP project
# then:
dbt deps
dbt run
dbt test
dbt docs generate && dbt docs serve
```

#### What it doesn't do

- No source data is bundled. You'd point the staging models at your own ad platform exports — whatever Fivetran / Stitch / Airbyte / custom pipeline you use to land the data in BigQuery first.
- No incremental materialisation. All models are tables. For real volume, the staging models would be `materialized: incremental` partitioned by date.
- No attribution logic. That sits downstream — see [ga4-attribution-models](https://github.com/GlitchG/ga4-attribution-models) for the SQL and [bigquery-meridian-mmm](https://github.com/GlitchG/bigquery-meridian-mmm) for the MMM that consumes mart-level output.

#### Related

- [ga4-attribution-models](https://github.com/GlitchG/ga4-attribution-models) — what to do with the data once it's clean
- [bigquery-meridian-mmm](https://github.com/GlitchG/bigquery-meridian-mmm) — Bayesian MMM that consumes mart output

MIT
