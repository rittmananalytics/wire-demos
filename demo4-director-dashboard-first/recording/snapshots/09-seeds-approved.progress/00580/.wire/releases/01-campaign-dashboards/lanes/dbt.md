# Lane: dbt

Release: 01-campaign-dashboards
Task: /wire:dbt-generate 01-campaign-dashboards, then /wire:dbt-validate 01-campaign-dashboards (dbt seed, dbt build on local DuckDB)
Owns: dbt/, .wire/releases/01-campaign-dashboards/dev/dbt_*.md, .wire/releases/01-campaign-dashboards/lanes/dbt.md
Dispatched: 2026-10-05 20:56 by orchestrator [910893ca]

## Items
- [x] dbt project scaffold with DuckDB profile
- [x] seeds copied from dev/seed_data
- [x] staging models (2)
- [x] warehouse models (5) with 18 tests
- [x] dbt seed
- [x] dbt build
- [x] validate checks

## Results

### Files created
- dbt/dbt_project.yml (profile claybrook; seed column_types; staging=view, warehouse=table; spine_start/end vars)
- dbt/profiles.yml (profile claybrook, target dev, type duckdb, path target/claybrook.duckdb, threads 4)
- dbt/.gitignore (target/, dbt_packages/, logs/, *.duckdb, .user.yml)
- dbt/packages.yml + dbt/package-lock.yml (dbt_utils 1.4.1)
- dbt/seeds/: campaign.csv, campaign_performance.csv, article.csv, page_engagement.csv (copied from approved dev/seed_data), _seeds.yml
- dbt/models/staging/: stg_campaign_performance.sql, stg_page_engagement.sql, _staging.yml
- dbt/models/warehouse/: campaign_dim.sql, content_dim.sql, date_dim.sql, campaign_performance_fct.sql, page_engagement_fct.sql, _warehouse.yml
- .wire/releases/01-campaign-dashboards/dev/dbt_models_summary.md

### dbt seed summary
Done. PASS=4 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=4
Rows: campaign 31, campaign_performance 883, article 30, page_engagement 741.

### dbt build summary
Done. PASS=29 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=29
(4 seeds, 2 view models, 5 table models, 18 data tests). dbt compile also succeeds (all refs resolve). No deprecation warnings.

### Test count
18 tests, all pass. Exactly the 18 planned in data_model_specification.md section 8:
campaign_dim (unique+not_null on campaign_pk, accepted_values on campaign_status),
content_dim (unique+not_null on content_pk),
date_dim (unique+not_null on date_day),
campaign_performance_fct (unique+not_null on pk, relationships campaign_fk and date_day, not_null impressions_delivered and impressions_eligible),
page_engagement_fct (unique+not_null on pk, relationships content_fk and date_day, not_null page_views).

### Warehouse row counts
campaign_dim 31, content_dim 30, date_dim 30 (2026-09-01..2026-09-30), campaign_performance_fct 883, page_engagement_fct 741.

### Values for status.md (orchestrator to write)
- artifacts.dbt.generate: complete
- artifacts.dbt.validate: pass
- models_count: 7 (2 staging, 5 warehouse) plus 4 seeds
- tests_count: 18
- tests_passed: 18, tests_failed: 0
- generated_date / validated_date: 2026-10-05

### Validate checks
- dbt test (via build): PASS, 18/18.
- dbt compile / dependency check: PASS, all ref() resolve, correct layer order.
- Materialization: warehouse=table, staging=view. PASS.
- SQL structure: s_ ref CTEs at top, final CTE in every model. PASS.
- Field ordering: keys, attributes, metrics, temporal. PASS.
- Testing coverage: every warehouse PK has unique+not_null; both facts' FKs have relationships tests; status enum has accepted_values. PASS.
- Documentation: all 7 models and every column documented in schema yml; 4 seeds documented. PASS.
- Type casting: dbt cross-db macros used (type_int, type_numeric, type_timestamp, current_timestamp, generate_surrogate_key, date_spine). PASS.
- sqlfluff: not installed in the environment; manual style review applied (4-space indent, lowercase, explicit intent). N/A.
- Convention linter (wire/scripts/lint_conventions.py): not present in this install; manual review applied.

### Deviations (intentional, not failures)
- R-17: model names use the SOW / LookML names (stg_campaign_performance, stg_page_engagement, campaign_dim, content_dim, date_dim, campaign_performance_fct, page_engagement_fct), not the generic stg_<group>__ / wh_<group>__ pattern. A standard Wire naming check would flag these; recorded as an intentional R-17 deviation.
- date_dim is keyed on date_day (the date value), not a surrogate _pk; facts carry date_day as the FK. Per data model specification section 4.
- Date columns use spec-fixed names (activity_date, date_day, booking_start_date, booking_end_date, publish_date) rather than the _dt suffix; the LookML layer references these names.
- dbt_updated_at keeps the DDL-fixed audit column name, not a _ts suffix.

### DuckDB-specific bits (noted for Phase 2 BigQuery)
- date_dim calendar parts use DuckDB functions: dayname, isodow, monthname, week, month, quarter, year, date_trunc('week', ...). Phase 2 on BigQuery replaces these with format_date / extract. The date spine itself uses dbt_utils.date_spine (portable).
- Everything else uses dbt cross-database macros and is portable to BigQuery.

### Notes
- dbt_utils 1.4.1 installed via dbt deps from dbt hub (package registry, not a client system). Local DuckDB only; no connection to BigQuery, dbt Cloud, Snowflake or any client system. ~/.dbt/profiles.yml was not used or edited.
- Logic kept per R-13: publication carried on campaign_dim and content_dim; unique_readers stored as the daily per-page count; facts store total_time_on_page_seconds and page_views (no pre-computed average). fill_rate_pct and cpm_gbp are semantic-layer measures (R-10).
- Did not run dbt-review (per brief).

state: complete — dbt seed PASS=4, dbt build PASS=29 (18/18 tests pass), 0 errors; 7 models + 4 seeds on local DuckDB; naming deviations recorded per R-17.
