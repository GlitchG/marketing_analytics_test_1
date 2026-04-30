# Architecture — marketing_analytics_sample_reporting

## Stack
BigQuery, dbt 1.8+, SQL, GitHub Actions CI, Looker Studio (output)

## Data Flow
```
Raw ad platform exports (Facebook Ads, Google Ads, TikTok Ads)
    → staging/ (stg_*.sql — clean, rename, type-cast raw columns)
        → marts/mart_paid_ads_performance.sql (unified cross-channel performance table)
            → analyses/qa_checks.sql (data quality validation)
                → Looker Studio dashboard (reads from mart output)
```

The staging layer normalises three different ad platform schemas into a consistent column naming convention. The mart layer joins them into a single table with a `platform` discriminator column.

## File Map
- `dbt_project.yml` — dbt project configuration (BigQuery profile, model paths)
- `models/staging/` — stg_facebook_ads.sql, stg_google_ads.sql, stg_tiktok_ads.sql + schema.yml (column docs + data tests)
- `models/marts/` — mart_paid_ads_performance.sql (UNION ALL of all three staging models) + schema.yml
- `analyses/qa_checks.sql` — data quality: row counts, NULL checks, spend sanity checks
- `.github/workflows/test-sql.yml` — CI: validates SQL syntax on every push

## Design Patterns
- **ELT with dbt**: Extract-and-Load is done by ad platform exports; dbt handles the Transform (staging → marts)
- **Staging as normalisation layer**: each stg_*.sql renames columns to a common convention (e.g. `spend`, `impressions`, `clicks`) regardless of source platform naming
- **Mart as UNION ALL**: mart_paid_ads_performance.sql unions all staging models with a `platform` column — simple, transparent, easy to add new platforms
- **QA as separate analysis**: qa_checks.sql lives in `analyses/`, not `models/` — it's diagnostic, not part of the production DAG
