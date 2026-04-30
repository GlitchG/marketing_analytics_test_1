# Architecture Decisions — marketing_analytics_sample_reporting

> Every decision with rationale and trade-offs.

## Decision Log

| Date | Decision | Rationale | Trade-offs |
|------|----------|-----------|------------|
| 2026-04 | UNION ALL over JOIN for mart | Three ad platforms have different granularity. UNION ALL with a `platform` column is the simplest, most transparent approach. | Requires consistent column naming in staging. If platforms have different metrics (e.g. TikTok has "video views", Google doesn't), those columns go NULL for other platforms. |
| 2026-04 | dbt over raw SQL scripts | dbt is the industry standard for analytics engineering. `dbt_project.yml` + schema.yml signals production readiness to hiring managers. | Adds learning curve. But README explains dbt basics for rookies. |
| 2026-04 | Three-platform scope (Facebook, Google, TikTok) | Covers the three most common paid channels. Enough to show multi-channel data modelling without being overwhelming. | LinkedIn, Twitter, Snapchat missing. Easy to add as new stg_*.sql files. |
| 2026-04 | QA checks in analyses/, not models | qa_checks.sql is diagnostic — row counts, NULL%, spend sanity. Not part of the production model DAG. Lives in analyses/ so it's discoverable but doesn't auto-run. | Must be run manually. Could be automated as dbt tests in schema.yml. |
| 2026-04 | Looker Studio as output, not included | The dashboard is built on the mart output. No dashboard JSON in the repo — keeps the repo focused on data modelling. | No visual portfolio piece in-repo. Hiring managers see SQL, not charts. |
| 2026-04-30 | .brain/ folder added | AI agent context: agents read .brain/index.md first. | Extra files. |
