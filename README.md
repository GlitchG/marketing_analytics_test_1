# Marketing Analytics — dbt Project

**Multi-channel paid ads data model for Facebook, Google, and TikTok.**

[![dbt](https://img.shields.io/badge/dbt-1.8+-orange?logo=dbt)](https://www.getdbt.com/)
[![BigQuery](https://img.shields.io/badge/BigQuery-data%20warehouse-4285F4?logo=googlecloud)](https://cloud.google.com/bigquery)
[![SQL](https://img.shields.io/badge/SQL-analytics-blue?logo=postgresql)](https://en.wikipedia.org/wiki/SQL)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

A portfolio project demonstrating **production-grade marketing analytics engineering** using dbt (data build tool) on BigQuery. Models raw paid ads data from Facebook, Google, and TikTok into clean, analysis-ready marts.

**Designed for:** Marketing analysts, data engineers, hiring managers — **zero prerequisites**. Just a free Google Cloud account.

---

## 📖 What You'll Learn

- ✅ **dbt project structure** — staging models, marts, schema documentation
- ✅ **Multi-channel data modeling** — Facebook Ads, Google Ads, TikTok Ads unified
- ✅ **Data quality checks** — QA SQL queries to validate transforms
- ✅ **Looker Studio ready** — output schema compatible with dashboards
- ✅ **Production patterns** — incremental models, source freshness, testing

---

## 🏗 Architecture

```
marketing_analytics_sample_reporting/
├── dbt_project.yml              # dbt project config
├── models/
│   ├── staging/                 # Raw → Cleaned
│   │   ├── stg_facebook_ads.sql  # Facebook Ads staging
│   │   ├── stg_google_ads.sql    # Google Ads staging
│   │   ├── stg_tiktok_ads.sql    # TikTok Ads staging
│   │   └── schema.yml            # Column docs + tests
│   └── marts/                   # Business-ready tables
│       ├── mart_paid_ads_performance.sql  # Unified performance mart
│       └── schema.yml            # Mart documentation
├── analyses/
│   └── qa_checks.sql            # Data quality validation
└── .github/workflows/
    └── test-sql.yml             # CI/CD: dbt parse + SQL lint
```

**Data flow:**
```
Facebook Ads (raw)  ──┐
Google Ads (raw)    ──┼──> staging models ──> mart_paid_ads_performance ──> Looker Studio
TikTok Ads (raw)    ──┘
```

---

## 🚀 Quick Start

### 1. Prerequisites

- Free [Google Cloud account](https://cloud.google.com/free)
- BigQuery enabled in your GCP project

### 2. Setup

```bash
# Clone the repo
git clone https://github.com/GlitchG/marketing_analytics_sample_reporting.git
cd marketing_analytics_sample_reporting

# Install dbt
pip install dbt-bigquery

# Create profiles.yml in ~/.dbt/ with your GCP project
# (see dbt_project.yml for project name)
```

### 3. Run

```bash
dbt deps              # Install dependencies
dbt run               # Build all models
dbt test              # Run data quality tests
dbt docs generate     # Generate documentation
dbt docs serve        # View docs in browser
```

---

## 📊 Models

### Staging Models

| Model | Source | Description |
|-------|--------|-------------|
| `stg_facebook_ads` | Facebook Ads API | Impressions, clicks, spend, conversions |
| `stg_google_ads` | Google Ads API | Campaign/ad group performance |
| `stg_tiktok_ads` | TikTok Ads API | Ad-level metrics |

### Marts

| Model | Description | Key Metrics |
|-------|-------------|-------------|
| `mart_paid_ads_performance` | Unified cross-channel view | Spend, impressions, clicks, CTR, CPC, conversions |

---

## 🔍 Data Quality

QA checks in `analyses/qa_checks.sql` validate:
- Row counts across channels
- Spend consistency
- Date range coverage
- Null checks on key columns

---

## 🧪 CI/CD

GitHub Actions automatically:
- ✅ Parses all dbt models (`dbt parse`)
- ✅ Lints SQL with SQLFluff (BigQuery dialect)
- ✅ Runs on every push to `main` and PR

---

## 🛠 Tech Stack

- **dbt** — data transformation
- **BigQuery** — cloud data warehouse
- **SQL** — analytics queries
- **GitHub Actions** — CI/CD
- **Looker Studio** — visualization (output-compatible)

---

## 📁 Related Portfolio Projects

- [GA4 Attribution Models](https://github.com/GlitchG/ga4-attribution-models) — SQL-based attribution modeling
- [Landing Page AB Testing](https://github.com/GlitchG/landing-page-ab-testing) — Statistical AB test analysis

---

## 📄 License

MIT © 2026 Gleb Baraniuk
