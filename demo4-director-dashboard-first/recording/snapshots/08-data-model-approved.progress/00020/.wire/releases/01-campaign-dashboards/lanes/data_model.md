# Lane: data_model

Release: 01-campaign-dashboards
Task: /wire:data_model-generate 01-campaign-dashboards (validate runs automatically)
Owns: .wire/releases/01-campaign-dashboards/design/data_model_specification.md, .wire/releases/01-campaign-dashboards/design/data_model.md, .wire/releases/01-campaign-dashboards/design/source_tables_ddl.sql, .wire/releases/01-campaign-dashboards/design/target_warehouse_ddl.sql, .wire/releases/01-campaign-dashboards/lanes/data_model.md
Dispatched: 2026-10-05 20:39 by orchestrator [910893ca]

## Items
- [x] generate data model specification and DDL
- [x] validate data model

## Results

### Files written
- design/data_model_specification.md
- design/source_tables_ddl.sql (4 source/seed tables)
- design/target_warehouse_ddl.sql (5 warehouse tables)
- data_model.md not written (the generate spec writes only data_model_specification.md)

### Models
Staging (2, view): stg_campaign_performance, stg_page_engagement
Warehouse (5, table): campaign_dim, content_dim, date_dim (3 dims); campaign_performance_fct, page_engagement_fct (2 facts)
Integration: none
Source/seed tables (4): campaign, campaign_performance, article, page_engagement

### Column counts
- Warehouse: campaign_dim 12, content_dim 8, date_dim 10, campaign_performance_fct 7, page_engagement_fct 8 (45 total)
- Staging: stg_campaign_performance 6, stg_page_engagement 7
- Source tables: campaign 11, campaign_performance 5, article 6, page_engagement 6 (28 total)

### Test count
18 dbt tests, all on the 5 warehouse models, meeting the SOW acceptance count of 18:
- campaign_dim: unique(campaign_pk), not_null(campaign_pk), accepted_values(campaign_status) = 3
- content_dim: unique(content_pk), not_null(content_pk) = 2
- date_dim: unique(date_day), not_null(date_day) = 2
- campaign_performance_fct: unique + not_null(campaign_performance_pk), relationships(campaign_fk), relationships(date_day), not_null(impressions_delivered), not_null(impressions_eligible) = 6
- page_engagement_fct: unique + not_null(page_engagement_pk), relationships(content_fk), relationships(date_day), not_null(page_views) = 5
The two fact relationships tests on campaign_fk and content_fk enforce referential integrity (FR-6, NFR-5).

### Validate result: PASS
- Critical checks: all pass, 0 failures.
- Naming checks: the generic Wire convention (stg_source__entity, wh_group__entity_fact) does not apply here. This dashboard_first release uses the names fixed by the SOW and the LookML explores (stg_campaign_performance, campaign_dim, campaign_performance_fct, etc.). All approved upstream artifacts use these names, so they are the governing contract. Deviation recorded as intentional, not a failure.
- Major warnings (2, non-blocking):
  1. FR/NFR codes (FR-6, FR-9, NFR-5) used without a local reference-key table; they are defined in requirements_specification.md and conceptual_model.md's reference key.
  2. Source seed DDL uses a column named `date` (campaign_performance, page_engagement); renamed to activity_date in staging and date_day in the warehouse, so no reserved word reaches the warehouse layer.
- Canonical Vertical Comparison: skipped. context.md has data_model_registry.vertical: null and cross_vertical_schemas: [], so no comparison section applies.

### Proposed for director confirmation
1. publication carried as an independent attribute on campaign_dim (and on content_dim), same made-up-name domain; no shared publication dimension in Phase 1. Needed by Fill Rate by Publication and the Publication filter on Campaign Performance (R-10).
2. date_dim is a generated date spine over the seed date range (no date.csv seed).
3. unique_readers stored as a daily per-page count. It must not be summed across days or pages to give true unique readers (double-counts returning or multi-page readers). The semantic layer will present the summed measure labelled as a daily-unique total (an upper bound), not true distinct readers. A true distinct count would need a reader-level grain the Phase 1 seed does not hold.
4. avg_time_on_page stored as components in page_engagement_fct: total_time_on_page_seconds (numerator) and page_views (denominator). The average is computed in the semantic layer as a weighted ratio sum(total)/sum(page_views), not a stored per-row average.

### Registry proposals (needs ruling)
- No vertical applied. The registry has no media, publishing, or advertising vertical, so there is no confident vertical match for Claybrook.
- Cross-vertical patterns event_tracking_and_sessionization and ga4_ecommerce (depends on the former) are structurally relevant to the Phase 2 GA4 audience source, but do not fit Phase 1: the page_engagement seed holds one pre-aggregated row per article page per day, coarser than the event/session grain those patterns model. Not applied in Phase 1. Flagged for ruling on whether to adopt either in Phase 2 when the GA4 source is wired in.
- Nothing written to context.md (lane does not write engagement context).

state: complete — 7 models (2 staging, 3 dims, 2 facts) + 4 source tables, 18 tests, validate PASS; 4 modelling defaults and the registry note raised for director confirmation.
