# Lane: seed_data

Release: 01-campaign-dashboards
Task: /wire:seed_data-generate 01-campaign-dashboards (validate runs automatically)
Owns: .wire/releases/01-campaign-dashboards/dev/seed_data/, .wire/releases/01-campaign-dashboards/dev/seed_data.md, .wire/releases/01-campaign-dashboards/lanes/seed_data.md
Dispatched: 2026-10-05 20:45 by orchestrator [910893ca]

## Items
- [x] campaign.csv
- [x] campaign_performance.csv
- [x] article.csv
- [x] page_engagement.csv
- [x] README and validate

## Results

### Files and row counts
| File | Rows | Cols | Notes |
|------|------|------|-------|
| campaign.csv | 31 | 10 | 24 Active, 3 Paused, 2 Completed, 2 Pending; 16 advertisers; 6 agencies (5 rows NULL agency) |
| campaign_performance.csv | 883 | 5 | one row per campaign per day |
| article.csv | 30 | 6 | 5 publications, 5 sections; 4 rows NULL author |
| page_engagement.csv | 741 | 6 | one row per article per day |

No date seed. date_dim is a generated spine (R-13).
Date range: 2026-09-01 to 2026-09-30.

### Shape vs approved mockups (broad, not exact)
- Average CPM: £6.73 (mockup £6.82); weekly CPM downward 6.91, 6.78, 6.67, 6.59, 6.52.
- Overall fill rate: 91.7% (mockup 92.4%).
- Fill rate by publication: Harbour 94.0, Metro 91.0, Coastline 89.0, Evening 95.0, Highgrove 88.0.
- Top advertiser revenue order: Northwind, Vellmont, Harlow & Finch, Brightsail, Carraway (matches doughnut).
- Page views 1.83M, sessions 738K, unique readers 531K, avg time 165s (2m45s).
- Campaign impressions delivered total ~60M vs mockup KPI 48.2M (31 campaigns booked vs top-8 detail table); anchored ratios match.

### 18 dbt test checks (data_model_specification.md section 8)
| # | Model | Column | Test | Result |
|---|-------|--------|------|--------|
| 1 | campaign_dim | campaign_pk | unique | PASS |
| 2 | campaign_dim | campaign_pk | not_null | PASS |
| 3 | campaign_dim | campaign_status | accepted_values (Active, Paused, Completed, Pending) | PASS |
| 4 | content_dim | content_pk | unique | PASS |
| 5 | content_dim | content_pk | not_null | PASS |
| 6 | date_dim | date_day | unique | PASS (spine over seed dates, distinct) |
| 7 | date_dim | date_day | not_null | PASS |
| 8 | campaign_performance_fct | campaign_performance_pk | unique | PASS (campaign_id+date distinct) |
| 9 | campaign_performance_fct | campaign_performance_pk | not_null | PASS |
| 10 | campaign_performance_fct | campaign_fk | relationships to campaign_dim.campaign_pk | PASS (no orphans) |
| 11 | campaign_performance_fct | date_day | relationships to date_dim.date_day | PASS |
| 12 | campaign_performance_fct | impressions_delivered | not_null | PASS |
| 13 | campaign_performance_fct | impressions_eligible | not_null | PASS |
| 14 | page_engagement_fct | page_engagement_pk | unique | PASS (article_id+date distinct) |
| 15 | page_engagement_fct | page_engagement_pk | not_null | PASS |
| 16 | page_engagement_fct | content_fk | relationships to content_dim.content_pk | PASS (no orphans) |
| 17 | page_engagement_fct | date_day | relationships to date_dim.date_day | PASS |
| 18 | page_engagement_fct | page_views | not_null | PASS |

18/18 PASS.

### Row-level constraints
- impressions_eligible >= impressions_delivered every row (fill rate <= 100%): PASS.
- revenue_gbp > 0 every row, consistent with CPM formula: PASS.
- unique_readers <= sessions <= page_views every row: PASS.
- No negative measures; NOT NULL columns populated: PASS.

### seed_data-validate result
PASS. 46 checks passed, 0 failed, 0 warnings. Covers structural (header, column
count, non-empty), PK uniqueness and not-null, FK integrity (no orphans), date
and numeric type validity, measure variation, date-range reasonableness,
categorical consistency.

### Values the spec would write to status.md (not written by this lane)
seed_data.generate: complete
seed_data.validate: pass
seed_data.generated_date: 2026-10-05
seed_data.validated_date: 2026-10-05
seed_data.seed_file_count: 4
seed_data.validation_checks: 46/46

state: complete — 4 seed CSVs (31 / 883 / 30 / 741 rows) plus README written; 18/18 dbt test checks pass; seed_data-validate PASS 46/0/0; nothing needs the director.
