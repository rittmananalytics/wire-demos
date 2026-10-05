# Visualization Catalog

**Client**: Claybrook Media Group
**Release**: 01-campaign-dashboards
**Release type**: dashboard_first (seeded)
**Generated**: 2026-10-05
**Source**: approved mockups (Priya Shah, Commercial Director, round 2), `design/dashboard_visualization_catalog.csv`, `design/dashboard_spec.md`

This catalog is generated from the approved mockup artifacts. It does not change the CSV or the dashboard spec. It is the input for the data model, the dbt build, and the LookML dashboards.

## Summary

- **Total Dashboards:** 2
- **Total Visualizations:** 19 (10 on Campaign Performance, 9 on Audience Engagement)
- **Unique Measures:** 10
- **Unique Dimensions:** 7 used in visualizations; 1 more (`agency`) used as a filter only, so 8 distinct dimensions the dashboards reference
- **Requirements Coverage:** dashboard-content requirements FR-2, FR-3 and FR-9 are covered (3/3). FR-1, FR-4 and FR-5 are process and artifact requirements, satisfied upstream or by this set of design files. The remaining FRs are downstream build requirements, not expressed as visualizations.

## Dashboards

### Campaign Performance

**Purpose:** Show how campaigns deliver against eligible inventory, the yield (CPM), and the revenue each advertiser and campaign produces. Supports the sales team in tracking live campaigns and spotting under-delivery. Explore: `campaign_performance`. Currency: GBP. Single page.

| # | Visualization | Type | Measures | Dimensions | Requirement(s) |
|---|--------------|------|----------|------------|-----------------|
| 1 | Impressions Delivered | KPI tile | impressions_delivered | none | FR-2 |
| 2 | Fill Rate | KPI tile | fill_rate_pct | none | FR-2, FR-9 |
| 3 | Average CPM | KPI tile | cpm_gbp | none | FR-2, FR-9 |
| 4 | Revenue Delivered | KPI tile | revenue_gbp | none | FR-2 (R-10) |
| 5 | Active Campaigns | KPI tile | active_campaign_count | none | FR-2 (R-10) |
| 6 | Impressions: Delivered vs Eligible | line | impressions_delivered, impressions_eligible | date (week) | FR-2 |
| 7 | Revenue Share by Advertiser | doughnut | revenue_gbp | advertiser | FR-2 |
| 8 | Fill Rate by Publication | bar | fill_rate_pct | publication | FR-2, FR-9 |
| 9 | Average CPM by Week | line | cpm_gbp | date (week) | FR-2, FR-9 (R-9) |
| 10 | Campaign Performance Detail | table | impressions_delivered, fill_rate_pct, cpm_gbp, revenue_gbp | campaign, advertiser, campaign_status | FR-2 (R-9 bottom of page) |

**Filters:** Date Range (date), Advertiser (advertiser), Agency (agency), Publication (publication), Campaign Status (campaign_status). Filters apply to all tiles; Run applies changes.

### Audience Engagement

**Purpose:** Show reader engagement across publications, sections and individual articles, so the sales team can describe audience reach and attention to advertisers. Engagement measures are fixed to four (ruling R-6). Explore: `page_engagement`. Single page.

| # | Visualization | Type | Measures | Dimensions | Requirement(s) |
|---|--------------|------|----------|------------|-----------------|
| 1 | Page Views | KPI tile | page_views | none | FR-3 (R-6) |
| 2 | Sessions | KPI tile | sessions | none | FR-3 (R-6) |
| 3 | Unique Readers | KPI tile | unique_readers | none | FR-3 (R-6) |
| 4 | Avg Time on Page | KPI tile | avg_time_on_page_seconds | none | FR-3 (R-6) |
| 5 | Page Views & Sessions by Day | line | page_views, sessions | date (day) | FR-3 |
| 6 | Page Views by Publication | doughnut | page_views | publication | FR-3 |
| 7 | Sessions by Publication | bar | sessions | publication | FR-3 |
| 8 | Avg Time on Page by Section | horizontal bar | avg_time_on_page_seconds | section | FR-3 |
| 9 | Top Articles by Engagement | table | page_views, sessions, unique_readers, avg_time_on_page_seconds | article, publication, section | FR-3 (R-11 mid-page) |

**Filters:** Date Range (date), Publication (publication), Section (section), Article (article). No agency filter on this dashboard (R-10). Filters apply to all tiles; Run applies changes.

## Measures Index

| Measure | Used In | Count |
|---------|---------|-------|
| impressions_delivered | Campaign #1, #6, #10 | 3 |
| impressions_eligible | Campaign #6 | 1 |
| fill_rate_pct | Campaign #2, #8, #10 | 3 |
| cpm_gbp | Campaign #3, #9, #10 | 3 |
| revenue_gbp | Campaign #4, #7, #10 | 3 |
| active_campaign_count | Campaign #5 | 1 |
| page_views | Audience #1, #5, #6, #9 | 4 |
| sessions | Audience #2, #5, #7, #9 | 4 |
| unique_readers | Audience #3, #9 | 2 |
| avg_time_on_page_seconds | Audience #4, #8, #9 | 3 |

## Dimensions Index

| Dimension | Used In | Count |
|-----------|---------|-------|
| date | Campaign #6, #9 (week grain); Audience #5 (day grain) | 3 |
| advertiser | Campaign #7, #10 | 2 |
| publication | Campaign #8; Audience #6, #7, #9 | 4 |
| campaign | Campaign #10 | 1 |
| campaign_status | Campaign #10 | 1 |
| section | Audience #8, #9 | 2 |
| article | Audience #9 | 1 |
| agency | filter only (Campaign Performance) | 0 in visualizations |

## Requirements Coverage

| Requirement | Addressed By | Status |
|-------------|-------------|--------|
| FR-2 Campaign performance dashboard (delivery, fill rate, CPM) | Campaign Performance #1-#10 | Covered |
| FR-3 Audience engagement dashboard (article and page level) | Audience Engagement #1-#9 | Covered |
| FR-9 LookML measures fill_rate_pct and cpm_gbp | Campaign #2, #3, #8, #9, #10 (both measures present) | Covered |
| FR-1 HTML mockups approved before build | Approved mockups (Priya Shah, round 2) | Covered (upstream) |
| FR-4 Viz catalog CSV | design/dashboard_visualization_catalog.csv | Covered (upstream) |
| FR-5 Dashboard spec and data model requirements | design/dashboard_spec.md, design/data_model_requirements.md | Covered |
| FR-6, FR-7, FR-8 seed, staging, warehouse models | Downstream build; not visualizations | Out of scope for this catalog |
| FR-10 Dashboard access | Not a visualization; open question in requirements | Out of scope for this catalog |
| FR-11 Seed render, no live refresh | Served by seed data; rendering requirement | Out of scope for this catalog |
| FR-12 Phase 2 refactor plan | Downstream (data_refactor); not visualizations | Out of scope for this catalog |

## Notes

- Every row in `dashboard_visualization_catalog.csv` appears here. No visualization is implicit.
- All advertiser, agency, campaign, publication and article names in the mockups are made up (R-1).
- Campaign Performance uses `publication` in visualization #8 and as a filter. The conceptual model describes publication only as an attribute of Article (content_dim). The campaign side needs its own publication attribute on `campaign_dim`. This is carried into `data_model_requirements.md` and flagged there for the data model stage.
- `date` is one dimension rolled to different grains: week on the campaign trend charts, day on the audience trend chart.
- No change was made to the CSV or the dashboard spec during generation.
