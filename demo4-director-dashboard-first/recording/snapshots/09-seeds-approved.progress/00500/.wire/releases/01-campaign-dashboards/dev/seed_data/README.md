# Seed Data Summary

## Overview

Seed data for release 01-campaign-dashboards, client Claybrook Media Group.
Release type: dashboard_first (seeded), Phase 1.
Generated: 2026-10-05.

Four CSV seed files back the two Phase 1 dashboards (Campaign Performance and
Audience Engagement). They let the dbt project build and the dashboards render
without any client data. Column contracts come from
`design/source_tables_ddl.sql`. All advertiser, agency, campaign, publication
and article names are made up (R-1); the fictional names match the approved
mockups so seeds and mockups agree. No personal data: readers are counted,
not identified.

`date_dim` has no seed file. It is a generated date spine over the seed date
range (R-13), built by the dbt project, not by this stage.

## Files

| File | Source table | Rows | Description |
|------|-------------|------|-------------|
| campaign.csv | campaign | 31 | Campaign master, one row per campaign. 24 Active, 3 Paused, 2 Completed, 2 Pending. |
| campaign_performance.csv | campaign_performance | 883 | Daily campaign delivery, one row per campaign per day, 2026-09-01 to 2026-09-30. |
| article.csv | article | 30 | Article master, one row per article, across 5 publications and 5 sections. |
| page_engagement.csv | page_engagement | 741 | Daily page engagement, one row per article per day, 2026-09-01 to 2026-09-30. |

## Dependency Order

Load dimension seeds before the fact seeds that reference them:

1. campaign.csv
2. article.csv
3. campaign_performance.csv (references campaign.csv)
4. page_engagement.csv (references article.csv)

```
campaign.csv ─────< campaign_performance.csv
article.csv ──────< page_engagement.csv
```

The two subject areas are independent in Phase 1. There is no join between a
campaign and the articles where its impressions were served.

## Foreign Key Relationships

| Child table | FK column | Parent table | PK column |
|------------|-----------|--------------|-----------|
| campaign_performance.csv | campaign_id | campaign.csv | campaign_id |
| page_engagement.csv | article_id | article.csv | article_id |

Every FK value in a fact file exists as a PK in its parent. No orphaned rows.

## Data Characteristics

- Date range: 2026-09-01 to 2026-09-30 (both facts).
- Publications (5): The Harbour Dispatch, Metro Ledger, The Coastline Review,
  Evening Compass, Highgrove Weekly.
- Sections (5): Features, Opinion, Lifestyle, Sport, News.
- Campaign status values: Active, Paused, Completed, Pending.
- Nullable columns carry some NULLs for downstream NULL handling: 5 campaigns
  have no agency (direct bookings), 4 articles have no author (wire copy).

Shapes reproduced from the approved mockups (broadly, not exactly):

| Measure | Mockup | Seed |
|---------|--------|------|
| Average CPM | £6.82 | £6.73 |
| Fill rate (overall) | 92.4% | 91.7% |
| Weekly CPM trend | downward | 6.91, 6.78, 6.67, 6.59, 6.52 |
| Fill rate by publication | 94 / 91 / 89 / 95 / 88 | 94.0 / 91.0 / 89.0 / 95.0 / 88.0 |
| Top advertiser revenue order | Northwind, Vellmont, Harlow & Finch, Brightsail, Carraway | same order |
| Page views (total) | 1.84M | 1.83M |
| Sessions (total) | 742K | 738K |
| Unique readers (total) | 531K | 531K |
| Avg time on page | 2m 38s (158s) | 2m 45s (165s) |

Campaign impressions delivered total about 60M, above the mockup KPI of 48.2M,
because the seed book carries 31 campaigns against the mockup detail table's
top 8. The anchored ratios (CPM, fill rate, advertiser order) match.

Row-level rules enforced on every row:

- impressions_eligible >= impressions_delivered, so fill rate <= 100%.
- revenue_gbp > 0 and consistent with CPM = revenue / delivered x 1000.
- unique_readers <= sessions <= page_views.
- total_time_on_page_seconds is a total (numerator); the semantic layer divides
  by page_views for a weighted average time on page (R-13).
- unique_readers is a daily per-page count. It is an upper bound if summed
  across days or pages, not a true distinct reader count.

## Validation

All 18 planned dbt tests (data_model_specification.md section 8) were checked
against the data: 18/18 pass. The seed_data-validate check set ran: 46 checks,
0 failures, 0 warnings.

## dbt Configuration

Add to `dbt_project.yml`:

```yaml
seeds:
  +schema: seed
  claybrook:
    +enabled: true
```

Column types follow `design/source_tables_ddl.sql` (BigQuery). Date columns are
YYYY-MM-DD. `rate_card_cpm_gbp` and `revenue_gbp` are decimals; the impression
and engagement counts are integers.
