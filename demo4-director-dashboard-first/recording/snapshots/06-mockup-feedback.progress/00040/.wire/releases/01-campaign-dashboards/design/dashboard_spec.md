# Dashboard Specification: Campaign Performance and Audience Engagement (Phase 1)

Client: Claybrook Media Group. Audience: advertising sales team. Approver: Priya Shah, Commercial Director.
Release type: dashboard_first (seeded). This spec captures data-visualization content only. It carries no colour, font, or Looker chrome detail.

All advertiser, agency, campaign, publication and article names in the mockups are fictional (decision R-1). Phase 1 runs on seed data; measures map to live GAM and GA4 sources in Phase 2 (out of scope here).

## Purpose

Give the advertising sales team two Looker dashboards:
1. Campaign Performance: delivery, fill rate and CPM for advertising campaigns, in GBP.
2. Audience Engagement: reader engagement at publication, section, article and page level.

Each dashboard is a single page. Both are backed by their own explore.

---

## Dashboard 1: Campaign Performance

Explore: `campaign_performance`. Currency: GBP.

**Purpose**: Show how campaigns are delivering against eligible inventory, the yield (CPM), and the revenue each advertiser and campaign is producing. Supports the sales team in tracking live campaigns and spotting under-delivery.

### Visualizations

1. **Impressions Delivered**: KPI tile
   - Measures: impressions_delivered
   - Dimensions: none (total for selected period)
   - Description: Total impressions delivered in the selected date range, with period-on-period trend.

2. **Fill Rate**: KPI tile
   - Measures: fill_rate_pct
   - Dimensions: none
   - Description: Share of eligible impressions that were filled, shown as a percentage with trend.

3. **Average CPM**: KPI tile
   - Measures: cpm_gbp
   - Dimensions: none
   - Description: Average cost per thousand impressions in GBP, with trend.

4. **Revenue Delivered**: KPI tile
   - Measures: revenue_gbp
   - Dimensions: none
   - Description: Total revenue delivered in GBP for the selected period, with trend.

5. **Active Campaigns**: KPI tile
   - Measures: active_campaign_count
   - Dimensions: none
   - Description: Count of campaigns with status Active in the selected period.

6. **Impressions: Delivered vs Eligible**: line chart
   - Measures: impressions_delivered, impressions_eligible
   - Dimensions: date (week)
   - Description: Weekly delivered impressions against eligible impressions, showing the delivery gap over time.

7. **Revenue Share by Advertiser**: doughnut chart
   - Measures: revenue_gbp
   - Dimensions: advertiser
   - Description: Share of total revenue by advertiser, top advertisers plus an Other group.

8. **Fill Rate by Publication**: bar chart
   - Measures: fill_rate_pct
   - Dimensions: publication
   - Description: Fill rate compared across publications.

9. **Average CPM by Campaign**: horizontal bar chart
   - Measures: cpm_gbp
   - Dimensions: campaign
   - Description: Average CPM for each campaign, ranked.

10. **Campaign Performance Detail**: table
    - Measures: impressions_delivered, fill_rate_pct, cpm_gbp, revenue_gbp
    - Dimensions: campaign, advertiser, campaign_status
    - Description: Row per campaign with impressions, fill rate (with inline bar), CPM, revenue and a status badge.

### Filter Dimensions
- Date Range (date)
- Advertiser (advertiser)
- Agency (agency)
- Publication (publication)
- Campaign Status (campaign_status)

### Interaction Notes
- Filters apply to all tiles on the page; Run applies filter changes.
- Single page (one tab: Delivery Overview). No cross-page drill in round 1.
- Table is sortable by any column.

---

## Dashboard 2: Audience Engagement

Explore: `page_engagement`.

**Purpose**: Show reader engagement across publications, sections and individual articles, so the sales team can describe audience reach and attention to advertisers. Engagement measures are fixed to four per decision R-6.

### Visualizations

1. **Page Views**: KPI tile
   - Measures: page_views
   - Dimensions: none
   - Description: Total page views in the selected period, with trend.

2. **Sessions**: KPI tile
   - Measures: sessions
   - Dimensions: none
   - Description: Total sessions in the selected period, with trend.

3. **Unique Readers**: KPI tile
   - Measures: unique_readers
   - Dimensions: none
   - Description: Distinct readers in the selected period, with trend.

4. **Avg Time on Page**: KPI tile
   - Measures: avg_time_on_page_seconds
   - Dimensions: none
   - Description: Mean time on page across articles, shown in minutes and seconds.

5. **Page Views & Sessions by Day**: line chart
   - Measures: page_views, sessions
   - Dimensions: date (day)
   - Description: Daily page views and sessions over the selected period.

6. **Page Views by Publication**: doughnut chart
   - Measures: page_views
   - Dimensions: publication
   - Description: Share of page views across publications.

7. **Sessions by Publication**: bar chart
   - Measures: sessions
   - Dimensions: publication
   - Description: Sessions compared across publications.

8. **Avg Time on Page by Section**: horizontal bar chart
   - Measures: avg_time_on_page_seconds
   - Dimensions: section
   - Description: Average time on page by content section, ranked.

9. **Top Articles by Engagement**: table
   - Measures: page_views, sessions, unique_readers, avg_time_on_page_seconds
   - Dimensions: article, publication, section
   - Description: Row per article with the four engagement measures; page views shown with an inline bar, section as a badge.

### Filter Dimensions
- Date Range (date)
- Publication (publication)
- Section (section)
- Article (article)

### Interaction Notes
- Filters apply to all tiles on the page; Run applies filter changes.
- Single page (one tab: Engagement Overview).
- Article and page level is served through the article and section dimensions on the explore.
- Table is sortable by any column.

---

## Measures summary

| Measure | Definition | Dashboard |
|---------|-----------|-----------|
| impressions_delivered | Impressions delivered for a campaign | Campaign Performance |
| impressions_eligible | Eligible (requested) impressions | Campaign Performance |
| fill_rate_pct | impressions_delivered / impressions_eligible, as a percentage | Campaign Performance |
| cpm_gbp | revenue_gbp / impressions_delivered x 1000, in GBP | Campaign Performance |
| revenue_gbp | Revenue delivered, in GBP | Campaign Performance |
| active_campaign_count | Count of campaigns with status Active | Campaign Performance |
| page_views | Page views | Audience Engagement |
| sessions | Sessions | Audience Engagement |
| unique_readers | Distinct readers | Audience Engagement |
| avg_time_on_page_seconds | Average time on page, in seconds | Audience Engagement |

`fill_rate_pct` and `cpm_gbp` are the two dynamic calculated measures named in the SOW and FR-9. The four engagement measures are fixed by decision R-6.
