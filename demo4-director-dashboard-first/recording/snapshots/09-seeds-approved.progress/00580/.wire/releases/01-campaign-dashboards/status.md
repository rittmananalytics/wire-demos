---
project_id: "20261005"
project_name: "01-campaign-dashboards"
project_type: "dashboard_first"
client_name: "Claybrook Media Group"
created_date: "2026-10-05"
last_updated: "2026-10-05"
current_phase: "build"

# Build profile — dashboard_first releases only. The release type declares
# profile_field: build_profile with seeded and live_data; /wire:new Step 6b asks
# which, and writes it here. Left out entirely for release types with no
# profiles: block. Until 4.0.0 nothing asked and default_profile applied
# silently, so live_data was only reachable by hand-editing this file.
# build_profile: seeded       # seeded | live_data
build_profile: seeded

jira:
  project_key: null
  structure: subtasks       # subtasks (default — one Task + 3 Sub-tasks per artifact) | single_issue (one Task per artifact, status transitions)
  epic_key: null
  artifacts:
    business_rules:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    requirements:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    workshops:
      task_key: null
      generate_key: null
      review_key: null
    conceptual_model:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    pipeline_design:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    data_model:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    seed_data:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    mockups:
      task_key: null
      generate_key: null
      review_key: null
    viz_catalog:
      task_key: null
      generate_key: null
    pipeline:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    orchestration:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    dbt:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    semantic_layer:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    dashboards:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    dbtcharts:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    agents_schema:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    data_refactor:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    data_quality:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    uat:
      task_key: null
      generate_key: null
      review_key: null
    deployment:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    training:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null
    documentation:
      task_key: null
      generate_key: null
      validate_key: null
      review_key: null

docstore:
  provider: null  # confluence | notion | both | null
  confluence:
    cloud_id: null
    space_key: null
    parent_page_id: null
    artifacts:
      requirements:
        page_id: null
        page_url: null
        last_synced: null
      workshops:
        page_id: null
        page_url: null
        last_synced: null
      conceptual_model:
        page_id: null
        page_url: null
        last_synced: null
      pipeline_design:
        page_id: null
        page_url: null
        last_synced: null
      data_model:
        page_id: null
        page_url: null
        last_synced: null
      seed_data:
        page_id: null
        page_url: null
        last_synced: null
      mockups:
        page_id: null
        page_url: null
        last_synced: null
      viz_catalog:
        page_id: null
        page_url: null
        last_synced: null
      pipeline:
        page_id: null
        page_url: null
        last_synced: null
      orchestration:
        page_id: null
        page_url: null
        last_synced: null
      dbt:
        page_id: null
        page_url: null
        last_synced: null
      dbt_staging:
        page_id: null
        page_url: null
        last_synced: null
      dbt_integration:
        page_id: null
        page_url: null
        last_synced: null
      dbt_warehouse:
        page_id: null
        page_url: null
        last_synced: null
      semantic_layer:
        page_id: null
        page_url: null
        last_synced: null
      dashboards:
        page_id: null
        page_url: null
        last_synced: null
      dbtcharts:
        page_id: null
        page_url: null
        last_synced: null
      agents_schema:
        page_id: null
        page_url: null
        last_synced: null
      data_refactor:
        page_id: null
        page_url: null
        last_synced: null
      data_quality:
        page_id: null
        page_url: null
        last_synced: null
      uat:
        page_id: null
        page_url: null
        last_synced: null
      deployment:
        page_id: null
        page_url: null
        last_synced: null
      training:
        page_id: null
        page_url: null
        last_synced: null
      documentation:
        page_id: null
        page_url: null
        last_synced: null
  notion:
    parent_page_id: null
    artifacts:
      requirements:
        page_id: null
        page_url: null
        last_synced: null
      workshops:
        page_id: null
        page_url: null
        last_synced: null
      conceptual_model:
        page_id: null
        page_url: null
        last_synced: null
      pipeline_design:
        page_id: null
        page_url: null
        last_synced: null
      data_model:
        page_id: null
        page_url: null
        last_synced: null
      seed_data:
        page_id: null
        page_url: null
        last_synced: null
      mockups:
        page_id: null
        page_url: null
        last_synced: null
      viz_catalog:
        page_id: null
        page_url: null
        last_synced: null
      pipeline:
        page_id: null
        page_url: null
        last_synced: null
      orchestration:
        page_id: null
        page_url: null
        last_synced: null
      dbt:
        page_id: null
        page_url: null
        last_synced: null
      dbt_staging:
        page_id: null
        page_url: null
        last_synced: null
      dbt_integration:
        page_id: null
        page_url: null
        last_synced: null
      dbt_warehouse:
        page_id: null
        page_url: null
        last_synced: null
      semantic_layer:
        page_id: null
        page_url: null
        last_synced: null
      dashboards:
        page_id: null
        page_url: null
        last_synced: null
      dbtcharts:
        page_id: null
        page_url: null
        last_synced: null
      agents_schema:
        page_id: null
        page_url: null
        last_synced: null
      data_refactor:
        page_id: null
        page_url: null
        last_synced: null
      data_quality:
        page_id: null
        page_url: null
        last_synced: null
      uat:
        page_id: null
        page_url: null
        last_synced: null
      deployment:
        page_id: null
        page_url: null
        last_synced: null
      training:
        page_id: null
        page_url: null
        last_synced: null
      documentation:
        page_id: null
        page_url: null
        last_synced: null

# Where the data model comes from. `derived` builds it from the approved
# requirements. Any other value names an external model that already holds
# entities, keys and cardinality, which logical_model reads rather than restates.
model_source: derived
# Set by /wire:utils-modality-link when model_source is modality. The directory
# holding modality_project.yaml, relative to the repo root, or absolute for a
# client-owned repository.
modality_path: null

# Advisory preconditions the consultant chose to proceed without, recorded by
# specs/utils/precondition_gate.md Step 2b. Each entry: artifact, unmet
# precondition, reason, date. A skip that is logged is visible; an omitted gate
# is not.
advisory_skips: []

artifacts:
  # Optional first phase. Discover, define and agree what the numbers mean before
  # design bakes a definition in. Warning-level gate, not blocking.
  business_rules:
    generate: not_applicable
    validate: not_applicable
    review: not_applicable
    file: null
    domains_covered: []
    generated_date: null
  requirements:
    generate: complete
    validate: pass
    review: approved
    reviewed_by: "Priya Shah, Commercial Director, Claybrook Media Group"
    reviewed_date: 2026-10-05
    file: requirements/requirements_specification.md
    generated_date: 2026-10-05
    generated_files:
      - requirements/requirements_specification.md
    revision_history: []
  workshops:
    generate: not_applicable
    review: not_applicable
    file: null
    generated_date: null
    generated_files: []
    revision_history: []
  conceptual_model:
    generate: complete
    validate: pass
    review: approved
    reviewed_by: "Priya Shah, Commercial Director, Claybrook Media Group"
    reviewed_date: 2026-10-05
    file: design/conceptual_model.md
    generated_date: 2026-10-05
    generated_files:
      - design/conceptual_model.md
    revision_history: []
  pipeline_design:
    generate: not_applicable
    validate: not_applicable
    review: not_applicable
    file: null
    generated_date: null
    generated_files: []
    revision_history: []
  # Optional. Worth running when identity resolution, cardinality or attribution
  # is contested, so those decisions get reviewed before they arrive as dbt models.
  logical_model:
    generate: not_applicable
    validate: not_applicable
    review: not_applicable
    file: null
    generated_date: null
  data_model:
    generate: complete
    validate: pass
    review: approved
    reviewed_by: "Mark Rittman (release director); modelling defaults accepted by Priya Shah, Commercial Director"
    reviewed_date: 2026-10-05
    file: design/data_model_specification.md
    generated_date: 2026-10-05
    generated_files:
      - design/data_model_specification.md
      - design/source_tables_ddl.sql
      - design/target_warehouse_ddl.sql
    revision_history: []
  seed_data:
    generate: complete
    validate: pass
    review: approved
    reviewed_by: "Mark Rittman (release director)"
    reviewed_date: 2026-10-05
    file: dev/seed_data/README.md
    generated_date: 2026-10-05
    generated_files:
      - dev/seed_data/campaign.csv
      - dev/seed_data/campaign_performance.csv
      - dev/seed_data/article.csv
      - dev/seed_data/page_engagement.csv
      - dev/seed_data/README.md
    revision_history: []
    seed_file_count: 4
  mockups:
    generate: complete
    review: approved
    reviewed_by: "Priya Shah, Commercial Director, Claybrook Media Group (written approval)"
    reviewed_date: 2026-10-05
    file: design/mockups/mockups_index.md
    generated_date: 2026-10-05
    generated_files:
      - design/mockups/campaign-performance.html
      - design/mockups/audience-engagement.html
      - design/mockups/mockups_index.md
      - design/dashboard_visualization_catalog.csv
      - design/dashboard_spec.md
    review_round: 2
    revision_history:
      - round: 1
        date: 2026-10-05
        outcome: changes_requested
        reviewed_by: "Priya Shah"
        changes: "Average CPM as weekly trend line (was bar chart); detail table moved to bottom of page"
      - round: 2
        date: 2026-10-05
        outcome: approved
        reviewed_by: "Priya Shah"
        changes: "None. Audience Engagement table stays mid-page (R-11)"
  viz_catalog:
    generate: complete
    file: design/visualization_catalog.md
    generated_date: 2026-10-05
    generated_files:
      - design/visualization_catalog.md
      - design/data_model_requirements.md
    revision_history: []
  pipeline:
    generate: not_applicable
    validate: not_applicable
    review: not_applicable
    file: null
    generated_date: null
    generated_files: []
    revision_history: []
  orchestration:
    generate: not_applicable
    validate: not_applicable
    review: not_applicable
    orchestration_tool: null
    generated_date: null
    generated_files: []
    revision_history: []
  dbt:
    generate: complete
    validate: pass
    review: not_started
    models_count: 7
    tests_count: 18
    generated_date: 2026-10-05
    validated_target: "local DuckDB (dbt/target/claybrook.duckdb), R-16"
    generated_files:
      - dbt/
      - .wire/releases/01-campaign-dashboards/dev/dbt_models_summary.md
    revision_history: []
  semantic_layer:
    generate: not_started
    validate: not_started
    review: not_started
    file: null
    generated_date: null
    generated_files: []
    revision_history: []
  dashboards:
    generate: not_started
    validate: not_started
    review: not_started
    file: null
    generated_date: null
    generated_files: []
    revision_history: []
  dbtcharts:
    generate: not_applicable
    validate: not_applicable
    review: not_applicable
    charts_dir: null
    boards: []
    generated_date: null
    generated_files: []
    revision_history: []
  agents_schema:
    generate: not_applicable
    validate: not_applicable
    review: not_applicable
    version: null
    destination: null
    providers: []
    skills: []
    workflow: null
    published: null
    generated_date: null
    generated_files: []
    revision_history: []
  data_refactor:
    generate: not_started
    validate: not_started
    review: not_started
    file: null
    generated_date: null
    generated_files: []
    revision_history: []
    tables_refactored: null
    staging_models_updated: null
  data_quality:
    generate: not_started
    validate: not_started
    review: not_started
    tests_count: null
    generated_date: null
    generated_files: []
    revision_history: []
  uat:
    generate: not_started
    review: not_started
    file: null
    generated_date: null
    generated_files: []
    revision_history: []
  deployment:
    generate: not_started
    validate: not_started
    review: not_started
    file: null
    generated_date: null
    generated_files: []
    revision_history: []
  training:
    generate: not_applicable
    validate: not_applicable
    review: not_applicable
    session_plans: []
    generated_date: null
    generated_files: []
    revision_history: []
  documentation:
    generate: not_applicable
    validate: not_applicable
    review: not_applicable
    file: null
    generated_date: null
    generated_files: []
    revision_history: []

agents:
  mode: orchestrated      # null | local | managed | orchestrated
  coordinator_session:
    user: "Mark Rittman"
    session_id: "910893ca-b5d8-4213-bb58-c93a748508fa"
    branch: "feature/claybrook-dashboard-first-setup"
    claimed_at: "2026-10-05 20:55"
    last_write: "2026-10-05 21:05"
  # The release claim. Written by whatever is going to dispatch (the orchestrating
  # session, or /wire:delegate), never by /wire:new or /wire:upgrade. A second
  # session that reads a live claim offers join / take-over / move instead of
  # dispatching. See specs/utils/director_operating_model.md, "The release claim".
  last_orchestrated: "2026-10-05 21:05"
  paused_at: null         # superseded by parked_decisions; kept so older readers still resolve
  active_sessions: []
  completed_sessions:
    - lane: dbt
      command: "/wire:dbt-generate 01-campaign-dashboards"
      state_file: lanes/dbt.md
      completed_at: "2026-10-05 21:05"
      summary: "7 models, 4 seeds; dbt build PASS=29 ERROR=0; 18/18 tests"
    - lane: seed_data
      command: "/wire:seed_data-generate 01-campaign-dashboards"
      state_file: lanes/seed_data.md
      completed_at: "2026-10-05 20:55"
      summary: "4 CSVs, 1,685 rows; 18/18 test checks; validate 46/46"
    - lane: data_model
      command: "/wire:data_model-generate 01-campaign-dashboards"
      state_file: lanes/data_model.md
      completed_at: "2026-10-05 20:45"
      summary: "7 models + 4 source tables, 18 tests, validate pass"
    - lane: viz_catalog
      command: "/wire:viz_catalog-generate 01-campaign-dashboards"
      state_file: lanes/viz_catalog.md
      completed_at: "2026-10-05 20:39"
      summary: "19 visualizations, 10 measures, 8 dimensions; data_model_requirements.md written"
    - lane: mockups-round-2
      command: "/wire:mockups-generate 01-campaign-dashboards"
      state_file: lanes/mockups-round-2.md
      completed_at: "2026-10-05 20:25"
      summary: "round 2: CPM weekly line, detail table to bottom"
    - lane: mockups
      command: "/wire:mockups-generate 01-campaign-dashboards"
      state_file: lanes/mockups.md
      completed_at: "2026-10-05 20:19"
      summary: "round 1: 2 dashboards, 19 visualizations"
    - lane: conceptual_model
      command: "/wire:conceptual_model-generate 01-campaign-dashboards"
      state_file: lanes/conceptual_model.md
      completed_at: "2026-10-05 20:13"
      summary: "generate complete, validate pass (12/12)"
    - lane: requirements
      command: "/wire:requirements-generate 01-campaign-dashboards"
      state_file: lanes/requirements.md
      completed_at: "2026-10-05 20:09"
      summary: "generate complete, validate pass (11/11)"

notes:
  - "Project created: 2026-10-05"
  - "Scope per SOW: business_rules, workshops, logical_model, dbtcharts, agents_schema, training, documentation not planned; no pipeline work (seed data only)"
  - "Mockups approved in writing by Priya Shah after round 2 (2026-10-05); SOW gate for dbt/LookML work met"
  - "Requirements approved by Priya Shah (Commercial Director) 2026-10-05"
  - "Ruling R-1: all sample and seed data uses made-up advertiser and publication names (see decisions.md)"

blockers: []

# Release budget — what an agent may spend on this release
# (specs/utils/director_operating_model.md, "Budget"). Absent/null means the
# defaults: lanes_max 4, no warehouse restriction, stop at decisions. The release
# director sets it in prose ("two lanes, nothing against a warehouse, stop at
# decisions") and the orchestrating session writes the block. /wire:upgrade never
# writes one: an absent block means no budget was set, not a budget of defaults.
budget:
  lanes_max: 4
  model_tier: default
  warehouse_spend: none        # local DuckDB only; nothing against BigQuery or any client system (R-16)
  stop_at: decisions
  set_by: "Mark Rittman"
  set_at: "2026-10-05"
#   lanes_max: 2                 # concurrent lanes; default 4
#   model_tier: default          # default | economy
#   warehouse_spend: none        # none | estimate_required | cap:<amount>
#   stop_at: decisions           # decisions | phase_end | never
#   set_by: "..."
#   set_at: "YYYY-MM-DD"

# Decisions waiting on the release director. Replaces the single agents.paused_at
# value below: a release can be waiting on more than one thing at once. Each
# entry carries id, artifact, kind (review | ruling | registry_proposal | budget |
# safety_gate), question, parked_at, and optionally awaiting. The first line of
# every orchestrated session is the count of these and their questions.
parked_decisions:
  - id: D-7
    artifact: dbt
    kind: review
    question: "Approve dbt project (7 models, 18/18 tests, dbt build PASS=29 ERROR=0 on local DuckDB)?"
    parked_at: "2026-10-05 21:05"
    awaiting: "Mark Rittman"
---

# Project Status: 01-campaign-dashboards

**Client**: Claybrook Media Group
**Project ID**: 20261005
**Type**: dashboard_first
**Created**: 2026-10-05
**Last Updated**: 2026-10-05

## Current Phase: Build

**Build profile**: seeded

## Next Action

dbt project built and tested on local DuckDB. Director review:
```
/wire:dbt-review 01-campaign-dashboards
```

## Artifact Status Summary

| Phase | Artifact | Generate | Validate | Review | Ready |
|-------|----------|----------|----------|---------|-------|
| **Requirements** | requirements | ✅ | ✅ | ✅ | ✅ |
| | workshops | N/A | - | N/A | N/A |
| **Design** | conceptual_model | ✅ | ✅ | ✅ | ✅ |
| | pipeline_design | N/A | N/A | N/A | N/A |
| | data_model | ✅ | ✅ | ✅ | ✅ |
| | mockups | ✅ | - | ✅ | ✅ |
| | viz_catalog *(dashboard_first only)* | ✅ | - | - | ✅ |
| **Development** | pipeline | N/A | N/A | N/A | N/A |
| | orchestration | N/A | N/A | N/A | N/A |
| | dbt | ✅ | ✅ | ⏸️ | ❌ |
| | seed_data *(dashboard_first only)* | ✅ | ✅ | ✅ | ✅ |
| | semantic_layer | ⏸️ | ⏸️ | ⏸️ | ❌ |
| | dashboards | ⏸️ | ⏸️ | ⏸️ | ❌ |
| | data_refactor *(dashboard_first only)* | ⏸️ | ⏸️ | ⏸️ | ❌ |
| **Testing** | data_quality | ⏸️ | ⏸️ | ⏸️ | ❌ |
| | uat | ⏸️ | - | ⏸️ | ❌ |
| **Deployment** | deployment | ⏸️ | ⏸️ | ⏸️ | ❌ |
| **Enablement** | training | N/A | N/A | N/A | N/A |
| | documentation | N/A | N/A | N/A | N/A |

**Legend**: ✅ Complete | 🔄 In Progress | ❌ Failed | ⏸️ Not Started | ⚠️ Blocked | N/A (not applicable)

## Iterations

Ticket-sized work done inside this release through `/wire:work` (`specs/work.md`). One row per iteration, updated in place; the detail is in `iterations/<ticket>.md`.

| Ticket | Title | Branch | PR | State | Opened | Closed |
|--------|-------|--------|----|-------|--------|--------|

## Notes

[Add project-specific notes here]

## Blockers

[Add any blockers here]

## Session History

| Date | Objective | Accomplished | Next Focus |
|------|-----------|--------------|------------|
