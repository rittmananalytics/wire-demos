# Requirements Specification: Campaign Performance and Audience Engagement Dashboards (Phase 1)

**Client**: Claybrook Media Group
**Project ID**: 01-campaign-dashboards
**Date**: 2026-10-05
**Version**: 1.0
**Release type**: dashboard_first (seeded profile)

**Sources used**: `engagement/sow.md` (Statement of Work, June 2026) and `engagement/context.md`. No meeting transcripts exist for this engagement: Fathom sync is disabled (decision R-4) and the `engagement/calls/` folder is empty. Every requirement below traces to one of these two documents by section name.

## 0. Goal Hierarchy

No `goal_hierarchy_captured` flag or `brief.md` was set by an earlier step, so goals were prioritised here from the SOW and context. All three Phase 1 business objectives are in scope for this engagement and are tagged Primary. Live GAM and GA4 data is Phase 2 and is a Future goal.

| Goal | Priority | Scope in this engagement | Source |
|------|----------|--------------------------|--------|
| Campaign performance dashboards (delivery, fill rate, CPM) | Primary | Full requirements, design, and delivery | context.md Business Objectives #1; SOW Engagement overview |
| Audience engagement dashboards at article and page level | Primary | Full requirements, design, and delivery | context.md Business Objectives #2; SOW In scope |
| Seed-to-source mapping so Phase 2 can switch to live data without redesign | Primary | Delivered as `data_refactor_plan.md` | context.md Business Objectives #3; SOW In scope |
| Live GAM and GA4 data through Fivetran | Future | Deferred to Phase 2 (separate SOW) | SOW Out of scope; context.md Overview |

**Primary analytical focus**: campaign delivery performance and audience engagement for the advertising sales team, served from seed data in Looker, with all dashboards approved as mockups before any build.

## 1. Executive Summary

Claybrook Media Group has no data platform today (context.md Current State). Phase 1 delivers a working Looker instance for the advertising sales team, powered by seed data, covering campaign performance (delivery, fill rate, CPM) and audience engagement (article and page level). The commercial director must approve interactive HTML mockups in writing before any dbt or LookML build work begins (SOW Acceptance criteria). Phase 1 also produces a seed-to-source mapping so Phase 2 can move to live Google Ad Manager (GAM) and Google Analytics 4 (GA4) data without redesign. Phase 2 itself is a separate SOW and is out of scope here.

## 2. Business Context

### 2.1 Background
Claybrook Media Group is a media publisher with an advertising sales team. No data platform exists (context.md Overview and Current State Architecture). Source: context.md.

### 2.2 Business Problem
The advertising sales team has no dashboards for campaign delivery performance or audience engagement. The business wants these dashboards built and approved on seed data first, then switched to live sources in a later phase. Source: context.md Overview; SOW Engagement overview.

### 2.3 Strategic Goals
1. Give the advertising sales team campaign performance dashboards (delivery, fill rate, CPM).
2. Give the team audience engagement dashboards at article and page level.
3. Prepare a seed-to-source mapping so Phase 2 can switch to live GAM and GA4 data without redesign.

Source: context.md Business Objectives.

### 2.4 Success Criteria
From SOW Acceptance criteria:
- Mockups approved in writing by the commercial director before any dbt or LookML work begins.
- `dbt seed && dbt run` completes with zero errors and all 18 dbt tests pass.
- All Looker dashboards render correctly with seed data and match the approved mockup structure.
- Phase 2 scope and timeline agreed and documented before Phase 1 engagement closes.

## 3. Stakeholders

| Role | Name | Responsibilities | Contact | Source |
|------|------|------------------|---------|--------|
| Commercial director, Claybrook | Commercial director (name TBC) [NEEDS CLARIFICATION] | Approves mockups in writing; sole sign-off authority | TBC [NEEDS CLARIFICATION] | context.md Key Stakeholders; SOW Key assumptions |
| Engagement lead, Rittman Analytics | Mark Rittman | Release director; delivery and approvals routing | mark.rittman@rittmananalytics.com | context.md Key Stakeholders |

Every functional requirement below is confirmed against the commercial director as the single named sign-off authority (SOW Key assumptions: the commercial director has authority to give written approval on behalf of the business; no further sign-off chain is required).

## 4. Functional Requirements

Each requirement is tagged with its goal priority and traced to a source. The Wire requirement dimensions covered across this section are: data sources (FR-7), transformations (FR-8), metrics (FR-2, FR-3), access and security (FR-10), and operational SLAs (FR-11).

### FR-1: Interactive HTML dashboard mockups [Primary]
**Priority**: High
**Description**: Produce interactive HTML dashboard mockups with the `dashboard-mock-developer` agent, iterated with the commercial director until approved in writing. Up to three review rounds are included, each with a one business day turnaround (SOW Timeline; SOW Key assumptions).
**Source**: SOW In scope; SOW Timeline Days 1-3.
**Confirmed by**: Commercial director (name TBC).
**Acceptance Criteria**:
- [ ] Mockups cover campaign performance and audience engagement content.
- [ ] Commercial director approves the mockups in writing before any dbt or LookML work begins.
- [ ] No more than three review rounds are consumed, or any overage is raised as a change.
- [ ] All advertiser, agency, campaign, and publication names shown are made up (decision R-1).

### FR-2: Campaign performance dashboard [Primary]
**Priority**: High
**Description**: A Looker dashboard for the advertising sales team showing campaign delivery, fill rate, and CPM, matching the approved mockup tile-for-tile.
**Source**: SOW In scope (Looker dashboards, explore `campaign_performance`); context.md Business Objectives #1.
**Confirmed by**: Commercial director (name TBC).
**Acceptance Criteria**:
- [ ] Shows delivery (impressions delivered), fill rate, and CPM.
- [ ] Fill rate uses the measure `fill_rate_pct`; CPM uses the measure `cpm_gbp` (SOW In scope, LookML semantic layer).
- [ ] Renders correctly with seed data.
- [ ] Matches the approved mockup structure tile-for-tile.

### FR-3: Audience engagement dashboard [Primary]
**Priority**: High
**Description**: A Looker dashboard showing audience engagement at article and page level, matching the approved mockup tile-for-tile.
**Source**: SOW In scope (explore `page_engagement`); context.md Business Objectives #2.
**Confirmed by**: Commercial director (name TBC).
**Acceptance Criteria**:
- [ ] Reports engagement at both article and page level.
- [ ] The specific audience engagement metrics and their definitions are confirmed with the commercial director. [NEEDS CLARIFICATION] The SOW names "audience engagement at article and page level" and the seed file `page_engagement.csv`, but does not list the exact metrics (for example page views, average time on page, scroll depth).
- [ ] Renders correctly with seed data.
- [ ] Matches the approved mockup structure tile-for-tile.

### FR-4: Viz catalog CSV [Primary]
**Priority**: High
**Description**: Produce `dashboard_visualization_catalog.csv`, derived atomically from the approved mockup.
**Source**: SOW In scope.
**Confirmed by**: Commercial director (name TBC) via mockup approval.
**Acceptance Criteria**:
- [ ] One catalog row per visualization in the approved mockup.
- [ ] Generated from the approved mockup, not ahead of approval.

### FR-5: Dashboard spec and data model requirements documents [Primary]
**Priority**: High
**Description**: Produce `dashboard_spec.md` and `data_model_requirements.md`.
**Source**: SOW In scope.
**Confirmed by**: Commercial director (name TBC) via mockup approval.
**Acceptance Criteria**:
- [ ] `dashboard_spec.md` describes each dashboard and tile.
- [ ] `data_model_requirements.md` lists the data the dashboards need.

### FR-6: Seed data files with referential integrity [Primary]
**Priority**: High
**Description**: Produce four CSV seed files with referential integrity: `campaign.csv`, `campaign_performance.csv`, `article.csv`, `page_engagement.csv`.
**Source**: SOW In scope.
**Confirmed by**: Commercial director (name TBC) via mockup approval (content derived from approved design).
**Acceptance Criteria**:
- [ ] All four files are present.
- [ ] Foreign keys resolve across the four files (referential integrity holds).
- [ ] All advertiser, agency, campaign, and publication names are made up (decision R-1).

### FR-7: dbt seed-based staging models [Primary] (dimension: data sources)
**Priority**: High
**Description**: Build dbt staging models from the seed files: `stg_campaign_performance` and `stg_page_engagement`. In Phase 1 the data source is the seed CSV layer, not live systems.
**Source**: SOW In scope (dbt project with seed-based staging models).
**Confirmed by**: Commercial director (name TBC) via mockup approval.
**Acceptance Criteria**:
- [ ] `stg_campaign_performance` and `stg_page_engagement` build from the seed files.
- [ ] `dbt seed && dbt run` completes with zero errors.

### FR-8: dbt warehouse models [Primary] (dimension: transformations)
**Priority**: High
**Description**: Build five dbt warehouse models: `campaign_dim`, `content_dim`, `date_dim`, `campaign_performance_fct`, `page_engagement_fct`.
**Source**: SOW In scope (five warehouse models).
**Confirmed by**: Commercial director (name TBC) via mockup approval.
**Acceptance Criteria**:
- [ ] All five models build with zero errors on `dbt run`.
- [ ] All 18 dbt tests pass (SOW Acceptance criteria).

### FR-9: LookML semantic layer [Primary]
**Priority**: High
**Description**: Build the LookML semantic layer: 5 views, 2 explores (`campaign_performance`, `page_engagement`), and dynamic calculated measures `fill_rate_pct` and `cpm_gbp`.
**Source**: SOW In scope (LookML semantic layer).
**Confirmed by**: Commercial director (name TBC) via mockup approval.
**Acceptance Criteria**:
- [ ] 5 views and 2 explores exist.
- [ ] `fill_rate_pct` and `cpm_gbp` are defined as calculated measures.
- [ ] Explores back the published dashboards.

### FR-10: Dashboard access [Primary] (dimension: access and security)
**Priority**: Medium
**Description**: The dashboards are used by Claybrook's advertising sales team (context.md Business Objectives). The access model, user groups, and any row-level restrictions in Looker are to be confirmed.
**Source**: context.md Business Objectives; SOW In scope (Looker dashboards published to production).
**Confirmed by**: Commercial director (name TBC) [pending].
**Acceptance Criteria**:
- [ ] Looker access groups and permissions for the advertising sales team are confirmed and applied. [NEEDS CLARIFICATION] Neither the SOW nor context.md states the Looker access model, user groups, or whether any row-level security is required.
- [ ] Confirm whether the seed data or Phase 2 live data contains any personal data needing restriction. [NEEDS CLARIFICATION] Not stated in either source; campaign and page engagement data may contain no personal data, but this needs confirmation before Phase 2.

### FR-11: Seed data render, no live refresh in Phase 1 [Primary] (dimension: operational SLAs)
**Priority**: Medium
**Description**: Phase 1 runs on static seed data. There is no live data feed and no scheduled refresh in this phase. Dashboards must render correctly from the seed layer.
**Source**: SOW Engagement overview (seed data); SOW Out of scope (no live GAM or GA4 data in Phase 1).
**Confirmed by**: Commercial director (name TBC) via mockup approval.
**Acceptance Criteria**:
- [ ] Dashboards render correctly from seed data with no live source connected.
- [ ] Phase 2 refresh cadence and operational SLAs are recorded as Phase 2 scope, not built here. [NEEDS CLARIFICATION] No refresh frequency or SLA is stated for Phase 2 in either source.

### FR-12: Phase 2 refactor plan (seed-to-source mapping) [Primary]
**Priority**: High
**Description**: Produce `data_refactor_plan.md` documenting the seed-to-source column mapping for GAM and GA4, so Phase 2 can switch to live data without redesign.
**Source**: SOW In scope (Phase 2 refactor plan); context.md Business Objectives #3.
**Confirmed by**: Commercial director (name TBC).
**Acceptance Criteria**:
- [ ] `data_refactor_plan.md` maps each seed column to its GAM or GA4 source column.
- [ ] Phase 2 scope and timeline are agreed and documented before Phase 1 closes (SOW Acceptance criteria).

## 5. Non-Functional Requirements

### NFR-1: Build correctness
`dbt seed && dbt run` completes with zero errors and all 18 dbt tests pass. Source: SOW Acceptance criteria.

### NFR-2: Mockup fidelity
Published Looker dashboards match the approved HTML mockups tile-for-tile. Source: SOW In scope; SOW Acceptance criteria.

### NFR-3: Approval gate
No dbt or LookML build work starts before the commercial director approves the mockups in writing. Source: SOW Acceptance criteria.

### NFR-4: Sample data realism and anonymity
Seed and mockup data looks realistic for a media advertising business, and uses only made-up advertiser, agency, campaign, and publication names. Source: decision R-1.

### NFR-5: Referential integrity
The four seed files hold referential integrity so warehouse models and tests build cleanly. Source: SOW In scope; SOW Acceptance criteria.

### NFR-6: Review turnaround
Each mockup review round completes within one business day; up to three rounds are included. Source: SOW Key assumptions; SOW Timeline.

## 6. Data Requirements

### 6.1 Data Sources

Phase 1 uses seed CSV files only. Live sources are Phase 2 and out of scope here.

| Source | Type | Refresh Rate | Volume | Owner | Source reference |
|--------|------|--------------|--------|-------|------------------|
| `campaign.csv` | Seed CSV (campaign master) | Static (no refresh in Phase 1) | [NEEDS CLARIFICATION] not stated | Rittman Analytics | SOW In scope |
| `campaign_performance.csv` | Seed CSV (delivery, fill rate, CPM inputs) | Static | [NEEDS CLARIFICATION] not stated | Rittman Analytics | SOW In scope |
| `article.csv` | Seed CSV (article master) | Static | [NEEDS CLARIFICATION] not stated | Rittman Analytics | SOW In scope |
| `page_engagement.csv` | Seed CSV (page engagement) | Static | [NEEDS CLARIFICATION] not stated | Rittman Analytics | SOW In scope |
| Google Ad Manager (GAM) | Live ad serving source | Phase 2 | Phase 2 | Claybrook | SOW Out of scope; context.md Current State (Phase 2) |
| Google Analytics 4 (GA4) | Live web engagement source | Phase 2 | Phase 2 | Claybrook | SOW Out of scope; context.md Current State (Phase 2) |

### 6.2 Data Quality Requirements
- Referential integrity across the four seed files.
- All 18 dbt tests pass.

Source: SOW In scope; SOW Acceptance criteria.

### 6.3 Data Governance
Not stated in the SOW or context.md. [NEEDS CLARIFICATION] Confirm whether any seed or Phase 2 source data is personal data, and whether governance or masking controls are required before Phase 2.

## 7. Technical Requirements

### 7.1 Platform
- BI: Looker (production instance).
- Warehouse: BigQuery.
- Transformation: dbt (dbt Cloud).

Assumed available before Day 6 (SOW Key assumptions; context.md Current State). Source: SOW; context.md.

### 7.2 Integrations
None in Phase 1. Fivetran connectors for GAM and GA4 are out of scope (Phase 2). Source: SOW Out of scope.

### 7.3 Tools and Technologies
- `dashboard-mock-developer` agent for HTML mockups.
- dbt for staging and warehouse models.
- LookML for the semantic layer.

Source: SOW In scope.

## 8. User Requirements

### 8.1 User Personas
- Advertising sales team (Claybrook): primary dashboard users (context.md Business Objectives).
- Commercial director (name TBC): approver and sole sign-off authority (context.md Key Stakeholders; SOW Key assumptions).

### 8.2 Use Cases
- A sales team member reviews campaign delivery, fill rate, and CPM for active campaigns. Example made-up campaign: advertiser "Northwind Beverages", campaign "Autumn Sparkling Launch" (illustrative only, per R-1).
- A sales team member reviews audience engagement for a publication's articles and pages. Example made-up publication: "The Harbour Dispatch" (illustrative only, per R-1).

Source: context.md Business Objectives; SOW In scope.

## 9. Deliverables

The ID column mints the D-codes. Each deliverable traces to the SOW In scope list.

| ID | Deliverable | Description | Acceptance Criteria | Agent Artifacts |
|----|------------|-------------|---------------------|-----------------|
| D1 | HTML dashboard mockups | Interactive mockups, iterated to written approval | Commercial director approves in writing before build; made-up names only | mockups |
| D2 | Viz catalog CSV | `dashboard_visualization_catalog.csv` derived from approved mockup | One row per visualization in the approved mockup | viz_catalog |
| D3 | Dashboard spec and data model requirements | `dashboard_spec.md` and `data_model_requirements.md` | Both documents present and consistent with the approved mockup | data_model |
| D4 | Seed data files | Four CSVs with referential integrity | All four present; foreign keys resolve; made-up names only | seed_data |
| D5 | dbt project | Staging (`stg_campaign_performance`, `stg_page_engagement`) and five warehouse models | `dbt seed && dbt run` zero errors; 18 tests pass | dbt |
| D6 | LookML semantic layer | 5 views, 2 explores, `fill_rate_pct` and `cpm_gbp` measures | Views, explores, and measures exist and back the dashboards | semantic_layer |
| D7 | Looker dashboards | Published dashboards matching mockups | Render with seed data; match mockups tile-for-tile | dashboards |
| D8 | Phase 2 refactor plan | `data_refactor_plan.md` seed-to-source mapping for GAM and GA4 | Each seed column mapped to its GAM or GA4 source; Phase 2 scope agreed | data_refactor |

## 10. Timeline and Milestones

| Milestone | Days | Deliverables | Source |
|-----------|------|--------------|--------|
| Mockup iteration and commercial director approval (up to 3 rounds) | Days 1-3 | D1 | SOW Timeline |
| Viz catalog, dashboard spec, data model requirements, seed data | Days 4-5 | D2, D3, D4 | SOW Timeline |
| dbt models, LookML semantic layer, Looker dashboards | Days 6-9 | D5, D6, D7 | SOW Timeline |
| Review, handover, Phase 2 scope agreement | Day 10 | D8 | SOW Timeline |

Engagement is time and materials, 10 working days. Source: SOW header; context.md SOW Reference.

## 11. Scope Management

### 11.1 In Scope
HTML mockups, viz catalog, dashboard spec and data model requirements, four seed files, dbt project (staging plus five warehouse models), LookML semantic layer (5 views, 2 explores, two measures), published Looker dashboards, and the Phase 2 refactor plan. Source: SOW In scope.

### 11.2 Out of Scope
From SOW Out of scope:
- Fivetran connector setup for Google Ad Manager or Google Analytics 4.
- Any work against live GAM or GA4 data (deferred to Phase 2).
- End-user training and documentation (deferred to Phase 2 or a standalone enablement engagement).
- Integration with Claybrook's CMS or editorial systems.

Also not planned per decision R-3: business_rules, workshops, logical_model, dbtcharts, agents_schema, training, documentation, and any pipeline work.

### 11.3 Not This Engagement (Future Goals)

| Goal | Why deferred | Suggested future release | Source |
|------|-------------|--------------------------|--------|
| Live GAM and GA4 data through Fivetran | Separate SOW; connector access not yet confirmed | Phase 2 (pipeline and data_refactor) | SOW Out of scope; context.md Overview |
| End-user training and documentation | Deferred by SOW | Phase 2 or standalone enablement | SOW Out of scope |
| CMS or editorial system integration | Out of SOW scope | TBD | SOW Out of scope |

### 11.4 Assumptions
From SOW Key assumptions:
- Commercial director is available for mockup review, one business day turnaround per round, up to three rounds.
- A Looker instance is provisioned and accessible before Day 6.
- A BigQuery project and dbt Cloud account are available and configured before Day 6.
- Claybrook confirms GAM and GA4 Fivetran credentials within 4 weeks of Phase 1 delivery, so Phase 2 can proceed without delay.
- The commercial director has authority to approve on behalf of the business; no further sign-off chain is required.

### 11.5 Dependencies
- Written mockup approval from the commercial director gates all dbt and LookML work (SOW Acceptance criteria).
- Looker, BigQuery, and dbt Cloud must be available before Day 6 (SOW Key assumptions).
- Phase 2 depends on GAM and GA4 Fivetran credentials being provided by Claybrook.

## 12. Risks and Mitigation

| Risk | Likelihood | Impact | Mitigation | Source |
|------|------------|--------|------------|--------|
| Platform not ready by Day 6 (Looker, BigQuery, dbt Cloud) | Medium | High | Confirm provisioning early; track as a dependency before Day 6 | SOW Key assumptions; context.md Current State (no platform today) |
| Mockup approval takes more than three rounds | Medium | Medium | Track rounds; raise any overage as a change to scope or timeline | SOW Timeline; SOW Key assumptions |
| Commercial director name and contact not yet known | High | Medium | Confirm the named approver before mockup review begins | context.md Key Stakeholders |
| Audience engagement metrics not specified | Medium | Medium | Confirm exact metrics and definitions during mockup iteration | SOW In scope (no metric list) |
| Phase 2 credentials delayed beyond 4 weeks | Medium | Medium | Flag in Phase 2 scope agreement at Day 10 | SOW Key assumptions |

## 13. Appendices

### Appendix A: Glossary
- **CPM**: cost per thousand impressions; the measure `cpm_gbp` in the semantic layer.
- **Fill rate**: share of eligible impressions that were filled; the measure `fill_rate_pct`.
- **Delivery**: impressions delivered for a campaign.
- **GAM**: Google Ad Manager, the Phase 2 ad serving source.
- **GA4**: Google Analytics 4, the Phase 2 web engagement source.
- **Seed data**: static CSV data used in Phase 1 in place of live sources.
- **dashboard_first**: Wire release type where mockups are approved before any build.

### Appendix B: References
- Statement of Work: `engagement/sow.md`
- Engagement context: `engagement/context.md`
- Release decisions and rulings: `releases/01-campaign-dashboards/decisions.md`

## Open Questions

These items are ambiguous or unstated in the sources and need the commercial director's input. Each carries a `[NEEDS CLARIFICATION]` tag at its point of use above.

1. Commercial director name and contact are not known (FR-1, FR-3, Section 3). Confirm the named approver before mockup review begins.
2. Exact audience engagement metrics and their definitions are not listed in the SOW (FR-3). The SOW names "article and page level" engagement and the `page_engagement.csv` seed, but not the specific metrics.
3. Looker access model, user groups, and any row-level security are not stated (FR-10).
4. Whether any seed or Phase 2 source data is personal data, and whether governance or masking is required (FR-10, Section 6.3).
5. Phase 2 refresh cadence and operational SLAs are not stated (FR-11, Section 6.1).
6. Seed data volumes per file are not stated (Section 6.1); confirm target row counts for realistic dashboards.

## Reference key

All codes used in this document (FR-n, NFR-n, D-n) are minted here. No external codes are cited, so no external reference key is needed.
