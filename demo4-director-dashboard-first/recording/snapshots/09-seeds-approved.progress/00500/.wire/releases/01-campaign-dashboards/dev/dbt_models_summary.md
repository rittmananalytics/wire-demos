# dbt Models Summary

Release: 01-campaign-dashboards (Claybrook Media Group, dashboard_first, seeded)
Generated: 2026-10-05
Target: local DuckDB (dbt/target/claybrook.duckdb), profile claybrook, target dev

## Models created (7)

### Seeds (4)
| Seed | Rows loaded |
|------|-------------|
| campaign | 31 |
| campaign_performance | 883 |
| article | 30 |
| page_engagement | 741 |

Seed column types are set in dbt_project.yml so dates load as DATE and
counts/money load as BIGINT / DECIMAL.

### Staging (2, views)
| Model | Grain |
|-------|-------|
| stg_campaign_performance | one row per campaign per day |
| stg_page_engagement | one row per article page per day |

### Warehouse (5, tables)
| Model | Type | Grain | Rows |
|-------|------|-------|------|
| campaign_dim | dimension | one row per campaign | 31 |
| content_dim | dimension | one row per article | 30 |
| date_dim | dimension | one row per calendar day | 30 |
| campaign_performance_fct | fact | one row per campaign per day | 883 |
| page_engagement_fct | fact | one row per article page per day | 741 |

date_dim is a generated spine (dbt_utils.date_spine) over 2026-09-01 to
2026-09-30, not a seed.

## Testing (18 tests, all pass)

| # | Model | Column | Test |
|---|-------|--------|------|
| 1-2 | campaign_dim | campaign_pk | unique, not_null |
| 3 | campaign_dim | campaign_status | accepted_values (Active, Paused, Completed, Pending) |
| 4-5 | content_dim | content_pk | unique, not_null |
| 6-7 | date_dim | date_day | unique, not_null |
| 8-9 | campaign_performance_fct | campaign_performance_pk | unique, not_null |
| 10 | campaign_performance_fct | campaign_fk | relationships to campaign_dim.campaign_pk |
| 11 | campaign_performance_fct | date_day | relationships to date_dim.date_day |
| 12-13 | campaign_performance_fct | impressions_delivered, impressions_eligible | not_null |
| 14-15 | page_engagement_fct | page_engagement_pk | unique, not_null |
| 16 | page_engagement_fct | content_fk | relationships to content_dim.content_pk |
| 17 | page_engagement_fct | date_day | relationships to date_dim.date_day |
| 18 | page_engagement_fct | page_views | not_null |

## Build result

dbt seed: PASS=4, ERROR=0.
dbt build: PASS=29 (4 seeds, 2 views, 5 tables, 18 tests), WARN=0, ERROR=0,
SKIP=0, TOTAL=29. All 18 tests pass.

## Naming deviations (intentional, per R-17 and the data model specification)

- Model names follow the SOW and LookML explores (stg_campaign_performance,
  campaign_dim, campaign_performance_fct, and so on), not the generic
  stg_<group>__ / wh_<group>__ Wire pattern. Per R-17.
- date_dim is keyed on the date value date_day, not a surrogate _pk. Facts
  carry date_day as the foreign key. Per data model specification section 4.
- Date columns use the spec-fixed names (activity_date, date_day,
  booking_start_date, booking_end_date, publish_date) rather than the _dt
  suffix. The LookML layer references these names.
- dbt_updated_at keeps the DDL-fixed audit column name, not a _ts suffix.

## DuckDB-specific SQL (Phase 2 BigQuery needs equivalents)

- date_dim calendar parts use DuckDB functions: dayname, isodow, monthname,
  week, month, quarter, year, date_trunc('week', ...). Phase 2 on BigQuery
  replaces these with format_date and extract.
- All other logic uses dbt cross-database macros (generate_surrogate_key,
  date_spine, type_int, type_numeric, type_timestamp, current_timestamp)
  and is portable to BigQuery.

## Calculated measures (not stored here)

fill_rate_pct, cpm_gbp, active_campaign_count, avg_time_on_page_seconds and
the unique_readers sum are semantic-layer measures (R-10). The facts store
components only.
