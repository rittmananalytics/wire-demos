# Dashboard Mockups Index: 01-campaign-dashboards

Round 2 interactive HTML mockups for Claybrook Media Group's advertising sales team.
Open each file in a browser to review. Each file is self-contained (no external assets).

## Round 2 changes (R-9, Priya Shah)

- Campaign Performance: the "Average CPM by Campaign" horizontal bar chart is replaced by an "Average CPM by Week" line chart (cpm_gbp, weekly, GBP). Weekly values average to the headline Average CPM of £6.82.
- Campaign Performance: the "Campaign Performance Detail" table moved to the bottom of the page, full width, below all charts.
- Audience Engagement: no change. Its "Top Articles by Engagement" table sits in the middle of the page, between the first chart row and the second chart row, not at the bottom. Flagged for the director to confirm with Priya.
- Everything else kept from round 1 (R-10): Revenue Delivered and Active Campaigns headline figures, current filters (no agency filter on Audience Engagement), one page per dashboard, CPM = revenue / delivered impressions x 1000, fill rate = delivered / eligible impressions.

All advertiser, agency, campaign, publication and article names are fictional (decision R-1).
Data is illustrative seed data for review only.

| File | Dashboard | Explore | Content |
|------|-----------|---------|---------|
| `mockups/campaign-performance.html` | Campaign Performance | `campaign_performance` | 5 KPI tiles, 4 charts, 1 detail table. Covers impressions delivered, fill rate (`fill_rate_pct`), CPM (`cpm_gbp`, GBP) and revenue. |
| `mockups/audience-engagement.html` | Audience Engagement | `page_engagement` | 4 KPI tiles, 4 charts, 1 article table. Covers page views, sessions, unique readers and average time on page, at article and page level. |

## Campaign Performance

- KPI tiles: Impressions Delivered, Fill Rate, Average CPM, Revenue Delivered, Active Campaigns
- Charts: Impressions Delivered vs Eligible (line, weekly), Revenue Share by Advertiser (doughnut), Fill Rate by Publication (bar), Average CPM by Week (line, weekly)
- Table: Campaign Performance Detail (campaign, advertiser, impressions, fill rate, CPM, revenue, status) at the bottom of the page, full width
- Filters: Date Range, Advertiser, Agency, Publication, Campaign Status

## Audience Engagement

- KPI tiles: Page Views, Sessions, Unique Readers, Avg Time on Page
- Charts: Page Views & Sessions by Day (line), Page Views by Publication (doughnut), Sessions by Publication (bar), Avg Time on Page by Section (horizontal bar)
- Table: Top Articles by Engagement (article, publication, section, page views, sessions, unique readers, avg time on page)
- Filters: Date Range, Publication, Section, Article

## Status

Round 2 generated, applying R-9. Pending commercial director (Priya Shah) review. Up to three review rounds are included per the SOW.
