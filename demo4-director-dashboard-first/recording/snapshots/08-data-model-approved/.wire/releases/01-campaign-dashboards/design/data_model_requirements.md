# Data Model Requirements: Campaign Performance and Audience Engagement (Phase 1)

**Client**: Claybrook Media Group
**Release**: 01-campaign-dashboards
**Release type**: dashboard_first (seeded)
**Generated**: 2026-10-05
**Derived from**: approved mockups (Priya Shah, round 2), `design/visualization_catalog.md`, `design/dashboard_spec.md`, `design/conceptual_model.md`
**Rulings applied**: R-1 (made-up names), R-6 (four engagement measures), R-8 (page is the grain of page engagement, no separate Page entity), R-10 (CPM and fill-rate formulas, Revenue Delivered and Active Campaigns kept)

This document lists every distinct measure and dimension the approved mockups need, the grain each dimension implies, the expected data type, and the calculation or business rule that defines each. It is the primary input for `mock-data-developer` (seed data) and `data-designer` (the formal data model). It does not define physical table names, primary keys or foreign keys; that is the data model stage.

The two subject areas are independent in Phase 1. There is no join between a campaign and the articles or pages where its impressions were served (conceptual model section 3). The two explores stay separate.

---

## 1. Measures

Ten distinct measures. Each measure's calculation is given as the aggregate the explore computes, with the row grain it aggregates from.

### Campaign Performance (explore `campaign_performance`, fact `campaign_performance_fct`)

Fact grain: one row per campaign per day.

| Measure | Calculation | Aggregates from | Data type | Business rule |
|---------|-------------|-----------------|-----------|---------------|
| impressions_delivered | sum(impressions_delivered) | campaign per day | integer (count) | Total impressions served for a campaign. Non-negative. |
| impressions_eligible | sum(impressions_eligible) | campaign per day | integer (count) | Eligible (requested) impressions. Non-negative. Must be >= delivered for a valid fill rate, so delivered/eligible <= 1. |
| revenue_gbp | sum(revenue_gbp) | campaign per day | decimal(12,2), GBP | Revenue delivered, in GBP. Headline figure kept (R-10). |
| fill_rate_pct | sum(impressions_delivered) / sum(impressions_eligible) x 100 | aggregate of the two sums, not an average of per-row ratios | decimal, percentage (1 dp) | Fill rate = delivered / eligible impressions (R-10). Calculated measure (FR-9). Aggregate-aware: compute the ratio on the summed numerator and denominator. Null or zero-guard when eligible = 0. |
| cpm_gbp | sum(revenue_gbp) / sum(impressions_delivered) x 1000 | aggregate of the two sums | decimal, GBP (2 dp) | CPM = revenue / delivered impressions x 1000 (R-10). Calculated measure (FR-9). Aggregate-aware. Null or zero-guard when delivered = 0. |
| active_campaign_count | count(distinct campaign) where campaign_status = 'Active' | campaign dimension | integer (count) | Count of campaigns with status Active in the selected period (R-10). Distinct on campaign, filtered to Active status. |

Notes:
- `fill_rate_pct` and `cpm_gbp` are the two dynamic calculated measures named in the SOW and FR-9. They must be computed from summed components so filters and roll-ups give the correct ratio. Averaging per-row ratios would be wrong.
- `revenue_gbp` and `active_campaign_count` are kept as headline figures by R-10.

### Audience Engagement (explore `page_engagement`, fact `page_engagement_fct`)

Fact grain: one row per article page per day. Page is the grain; there is no separate Page entity (R-8). The four measures are fixed by R-6.

| Measure | Calculation | Aggregates from | Data type | Business rule |
|---------|-------------|-----------------|-----------|---------------|
| page_views | sum(page_views) | article page per day | integer (count) | Total page views. Non-negative. |
| sessions | sum(sessions) | article page per day | integer (count) | Total sessions. Non-negative. |
| unique_readers | distinct readers | see note | integer (count) | Distinct readers (R-6). See the unique_readers modelling note below. |
| avg_time_on_page_seconds | sum(total_time_on_page_seconds) / sum(page_views) | article page per day | decimal, seconds | Mean time on page across the selection, weighted by page views. Displayed in minutes and seconds on the KPI tile (display only). See the average modelling note below. |

Modelling notes carried to the data model and seed stages:

1. **unique_readers cannot be summed across days or pages.** A reader who returns on two days, or reads two pages, is one unique reader but would be counted twice by a sum of daily per-page figures. A correct distinct count needs a reader-level grain, which the Phase 1 seed does not hold. Two options for the data model stage to choose from:
   - Store a daily per-page `unique_readers` count in the fact and expose the measure as a sum, documenting that it over-counts across days and pages (an upper bound). Simplest for seed data.
   - Seed a reader identifier at a finer grain and expose a true count(distinct reader_id). More faithful, more seed data.
   This is a decision for the data model stage, not resolved here.

2. **avg_time_on_page_seconds must be a weighted average.** To average correctly under filters and roll-ups, the fact should carry a total time field (`total_time_on_page_seconds`) and a denominator (`page_views`), and the measure computes sum(total) / sum(denominator). Storing only a per-row average and averaging those averages would be wrong. The data model stage should store the components, not the pre-computed average.

---

## 2. Dimensions

Eight distinct dimensions. For each, the grain it implies (the level one value of the dimension sits at), the data type, the model it belongs to, and notes.

| Dimension | Grain implied | Data type | Belongs to | Notes |
|-----------|---------------|-----------|-----------|-------|
| campaign | one campaign | string (name; id in the model) | campaign_dim | Backs the detail table and the Active Campaigns measure. Made-up names (R-1). |
| advertiser | one advertiser (many campaigns per advertiser) | string | campaign_dim (attribute) | Attribute of campaign, not a separate dimension (conceptual model section 4). Used in Revenue Share by Advertiser and the detail table, and as a filter. Made-up names (R-1). |
| agency | one agency (many campaigns per agency) | string | campaign_dim (attribute) | Attribute of campaign. Filter only on Campaign Performance; not in any visualization. No agency filter on Audience Engagement (R-10). Made-up names (R-1). |
| campaign_status | one status value | string (enum) | campaign_dim (attribute) | Values such as Active, Paused, Completed, Pending (set final domain at seed stage). Drives the Active Campaigns measure (status = 'Active'), the table status badge, and the Campaign Status filter. |
| publication | one publication | string | content_dim (article side) and campaign_dim (campaign side) | See the publication modelling note below. Made-up names (R-1). |
| date | one calendar day | date | date_dim | Shared by both facts. Rolled to week on the campaign trend charts (Impressions Delivered vs Eligible, Average CPM by Week), used at day grain on the audience trend chart (Page Views & Sessions by Day). Implies date_dim carries a week attribute (week start date or ISO week) and a day attribute. See the date_dim note below. |
| article | one article (page) | string (title; id in the model) | content_dim | Article-level reporting is the page-grain engagement rolled up to the article (R-8). Used in Top Articles by Engagement and as a filter. Made-up titles (R-1). |
| section | one content section (many articles per section) | string | content_dim (attribute) | Attribute of article. Used in Avg Time on Page by Section, the article table, and the Section filter. |

Modelling notes carried to the data model stage:

1. **publication on the campaign side.** The Campaign Performance dashboard uses `publication` in the Fill Rate by Publication chart and as a filter (both approved, kept by R-10). The conceptual model describes publication only as an attribute of Article (content_dim). For the campaign dashboard to group and filter by publication, `campaign_dim` must carry its own publication attribute: the publication whose inventory the campaign ran against. In Phase 1 the two subject areas do not share a publication dimension and do not join (conceptual model section 3), so publication is modelled as an independent string attribute on each of `campaign_dim` and `content_dim`, drawing from the same domain of made-up publication names (R-1). This is a small gap versus the conceptual model wording and is flagged for the data model stage and the director (see section 6).

2. **date_dim has no seed file.** The SOW seed list is `campaign.csv`, `campaign_performance.csv`, `article.csv`, `page_engagement.csv`. There is no `date.csv`. `date_dim` (in the SOW warehouse scope and the conceptual model) is a generated date spine covering the seed date range, not a seed-sourced table. The data model stage should build it as a generated spine with day, week, month, quarter, year and day-of-week attributes.

---

## 3. Grain summary

| Entity / model | Grain | Keys implied |
|----------------|-------|--------------|
| campaign_performance_fct | one row per campaign per day | campaign, date |
| page_engagement_fct | one row per article page per day (page is the grain, no separate Page entity, R-8) | article (page), date |
| campaign_dim | one row per campaign | campaign |
| content_dim | one row per article | article |
| date_dim | one row per calendar day | date |

---

## 4. Mapping to the SOW seeds, staging, warehouse and explores

The columns below are the data the dashboards need. Final column names and keys are set at the data model and seed stages.

### Seeds

| Seed file | Holds | Columns the dashboards need |
|-----------|-------|------------------------------|
| campaign.csv | Campaign master | campaign, advertiser, agency, campaign_status, publication, booking start date, booking end date, booked impression goal, rate card CPM |
| campaign_performance.csv | Daily campaign delivery | campaign reference, date, impressions_delivered, impressions_eligible, revenue_gbp |
| article.csv | Article master | article, publication, section, author, publish date |
| page_engagement.csv | Daily page engagement | article reference, date, page_views, sessions, unique_readers, total_time_on_page_seconds (store total, not the pre-computed average) |

Referential integrity (FR-6, NFR-5): `campaign_performance.csv` references `campaign.csv`; `page_engagement.csv` references `article.csv`. All names made up (R-1).

### Staging

| Staging model | Built from | Purpose |
|---------------|-----------|---------|
| stg_campaign_performance | campaign_performance.csv (and campaign.csv for campaign attributes if needed) | Clean, typed daily campaign delivery |
| stg_page_engagement | page_engagement.csv (and article.csv for article attributes if needed) | Clean, typed daily page engagement |

### Warehouse

| Warehouse model | Built from | Grain | Carries |
|-----------------|-----------|-------|---------|
| campaign_dim | campaign.csv | one per campaign | campaign, advertiser, agency, campaign_status, publication |
| content_dim | article.csv | one per article | article, publication, section |
| date_dim | generated date spine | one per day | date, day, week, month, quarter, year, day of week |
| campaign_performance_fct | stg_campaign_performance | campaign per day | impressions_delivered, impressions_eligible, revenue_gbp; references campaign_dim and date_dim |
| page_engagement_fct | stg_page_engagement | article page per day | page_views, sessions, unique_readers, total_time_on_page_seconds; references content_dim and date_dim |

### Explores

| Explore | Joins | Measures | Dimensions |
|---------|-------|----------|------------|
| campaign_performance | campaign_performance_fct + campaign_dim + date_dim | impressions_delivered, impressions_eligible, revenue_gbp, fill_rate_pct, cpm_gbp, active_campaign_count | campaign, advertiser, agency, campaign_status, publication, date (day and week) |
| page_engagement | page_engagement_fct + content_dim + date_dim | page_views, sessions, unique_readers, avg_time_on_page_seconds | article, publication, section, date (day) |

---

## 5. Calculated measures (FR-9)

| Measure | Formula (R-10) | Notes |
|---------|----------------|-------|
| fill_rate_pct | sum(impressions_delivered) / sum(impressions_eligible) x 100 | Ratio of summed components, aggregate-aware. Guard against eligible = 0. |
| cpm_gbp | sum(revenue_gbp) / sum(impressions_delivered) x 1000 | Ratio of summed components, aggregate-aware. Guard against delivered = 0. GBP. |

`avg_time_on_page_seconds` is also a ratio measure (sum of total time / sum of page views) and must be modelled aggregate-aware, even though it is not named as a dynamic calculated measure in the SOW.

---

## 6. Items flagged for the data model stage and the director

1. **publication on the campaign side.** Needed by the approved Campaign Performance dashboard (Fill Rate by Publication, Publication filter; kept by R-10) but described in the conceptual model only as an Article attribute. The data model should carry publication as an independent attribute on `campaign_dim` as well as `content_dim`, same made-up-name domain, no shared dimension in Phase 1. Director to confirm.
2. **date_dim has no seed.** Build as a generated date spine over the seed date range. Not in the four-file SOW seed list, which is expected.
3. **unique_readers aggregation.** Choose between a summed daily upper-bound count and a true distinct count from a seeded reader identifier. Affects the seed design.
4. **avg_time_on_page_seconds.** Store total time plus a denominator in the fact; do not store a pre-computed per-row average.

None of these change the approved mockups, the CSV catalog, or the dashboard spec. They are modelling decisions for the data model stage.
