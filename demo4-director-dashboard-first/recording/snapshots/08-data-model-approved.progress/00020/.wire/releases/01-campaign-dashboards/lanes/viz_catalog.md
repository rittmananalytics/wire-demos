# Lane: viz_catalog

Release: 01-campaign-dashboards
Task: /wire:viz_catalog-generate 01-campaign-dashboards, then write design/data_model_requirements.md
Owns: .wire/releases/01-campaign-dashboards/design/visualization_catalog.md, .wire/releases/01-campaign-dashboards/design/data_model_requirements.md, .wire/releases/01-campaign-dashboards/lanes/viz_catalog.md
Dispatched: 2026-10-05 20:34 by orchestrator [910893ca]

## Items
- [x] visualization_catalog.md from the approved catalog CSV and spec
- [x] data_model_requirements.md

## Results

Files written:
- design/visualization_catalog.md
- design/data_model_requirements.md

Counts:
- Dashboards: 2 (Campaign Performance, Audience Engagement)
- Visualizations: 19 (10 + 9); every CSV row represented, none implicit
- Distinct measures: 10 (6 campaign, 4 audience)
- Distinct dimensions: 8 (7 used in visualizations; agency is filter-only)
- Calculated measures: fill_rate_pct, cpm_gbp (FR-9), per R-10 formulas

Discrepancies and modelling items flagged for the data model stage / director (none change the approved CSV, spec or mockups):
1. publication is used on the Campaign Performance dashboard (Fill Rate by Publication chart + filter, kept by R-10) but the conceptual model ties publication only to Article. The data model must carry publication as an attribute on campaign_dim as well as content_dim; no shared publication dimension in Phase 1. Needs director confirmation.
2. date_dim has no seed file in the SOW four-file list; build as a generated date spine over the seed date range.
3. unique_readers cannot be summed across days/pages without over-counting; choose summed upper-bound vs true distinct from a seeded reader id.
4. avg_time_on_page_seconds must be a weighted average; store total time + denominator in the fact, not a pre-computed per-row average.

The viz_catalog-generate spec did not require any edit to the CSV or dashboard spec; none was made. Approved artifacts unchanged.

## Values the spec would write (orchestrator to apply; lane does not write status.md or execution_log.md)
- execution_log row: `| 2026-10-05 HH:MM | /wire:viz_catalog-generate | complete | Generated visualization_catalog.md — 2 dashboards, 19 visualizations, 10 measures, 8 dimensions | Mark Rittman | viz_catalog | n/a | n/a | n/a |`
- status.md artifacts.viz_catalog:
  - generate: complete
  - generated_date: 2026-10-05
  - file: design/visualization_catalog.md
  - generated_files: [design/visualization_catalog.md]
- data_model_requirements.md also written (supports D3 / data_model artifact). Data model generate/review not run by this lane (R-12: run stops at data model review).
- No Jira, Linear, document store or Fathom sync (R-4, lane budget).

state: complete — visualization_catalog.md and data_model_requirements.md written; 2 dashboards, 19 visualizations, 10 measures, 8 dimensions; 4 modelling items flagged for the data model stage, 1 (publication on campaign_dim) needs director confirmation
