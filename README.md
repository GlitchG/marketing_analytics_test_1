# Marketing Analytics — dbt Project

Multi-channel paid ads data model for Facebook, Google, and TikTok.  

## Architecture

```
Raw CSVs (BigQuery)
    └── Staging layer (views)       — normalize types, rename fields, add platform column
            └── Mart layer (table)  — UNION ALL + derived metrics
                    └── Looker Studio dashboard
```

### Why two layers?

- **Staging** handles source-specific quirks: field renames (`spend` → `cost`, `adgroup_id` → `ad_group_id`), type casts, NULL padding for missing columns.
- **Mart** is the single source of truth for all downstream consumers. Derived metrics (CTR, CPA, ROAS, VTR, VCR) are computed here — not in the BI tool — so every chart uses identical definitions.

## Project Structure

```
marketing_analytics/
├── dbt_project.yml
├── README.md
├── models/
│   ├── staging/
│   │   ├── stg_facebook_ads.sql
│   │   ├── stg_google_ads.sql
│   │   ├── stg_tiktok_ads.sql
│   │   └── schema.yml
│   └── marts/
│       ├── mart_paid_ads_performance.sql
│       └── schema.yml
└── analyses/
    └── qa_checks.sql
```

## Data Sources

| Table | Rows | Date range | Platform |
|---|---|---|---|
| `facebook_ads` | 110 | 2024-01-01 – 2024-01-30 | Facebook |
| `google_ads` | 110 | 2024-01-01 – 2024-01-30 | Google |
| `tiktok_ads` | 110 | 2024-01-01 – 2024-01-30 | TikTok |

## Mart Grain

`mart_paid_ads_performance` — one row per **platform × campaign × ad_group × date**

## Key Metrics Defined

| Metric | Formula | Notes |
|---|---|---|
| CTR | clicks / impressions | — |
| CPC | cost / clicks | — |
| CPM | (cost / impressions) × 1000 | — |
| CPA | cost / conversions | NULL-safe |
| ROAS | conversion_value / cost | Google only (other platforms have NULL conversion_value) |
| VTR | video_views / impressions | Facebook + TikTok |
| VCR | video_completions / video_views | TikTok only |

All divisions use `SAFE_DIVIDE()` — no divide-by-zero errors.

## QA Checks

See `analyses/qa_checks.sql` for:
- Row counts per platform
- No negative spend or impressions
- CTR sanity (must be ≤ 1)
- Date coverage and gap detection

## Note on dbt

This project follows dbt conventions (layered models, schema.yml documentation,
YAML tests) but SQL was executed directly in BigQuery for this assignment.

To deploy with dbt-bigquery, configure `profiles.yml` with your GCP credentials
and run `dbt run && dbt test`.

## Sample of dashboard
[Click here](https://lookerstudio.google.com/reporting/ffbf5968-452d-40d8-bba7-1f54b5bcd0cf)
