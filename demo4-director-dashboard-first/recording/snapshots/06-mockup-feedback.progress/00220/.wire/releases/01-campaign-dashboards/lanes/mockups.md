# Lane: mockups

Release: 01-campaign-dashboards
Task: /wire:mockups-generate 01-campaign-dashboards (dashboard_first, round 1 only)
Owns: .wire/releases/01-campaign-dashboards/design/mockups/, .wire/releases/01-campaign-dashboards/design/dashboard_visualization_catalog.csv, .wire/releases/01-campaign-dashboards/design/dashboard_spec.md, .wire/releases/01-campaign-dashboards/design/mockups.md, .wire/releases/01-campaign-dashboards/lanes/mockups.md
Dispatched: 2026-10-05 20:10 by orchestrator [910893ca]

## Items
- [x] campaign-performance.html
- [x] audience-engagement.html
- [x] mockups index (design/mockups.md)
- [x] dashboard_visualization_catalog.csv
- [x] dashboard_spec.md

## Results

### Files written
- design/mockups/campaign-performance.html (self-contained, 4 Chart.js charts, no external image assets)
- design/mockups/audience-engagement.html (self-contained, 4 Chart.js charts, no external image assets)
- design/mockups.md (index of both dashboards)
- design/dashboard_visualization_catalog.csv (19 rows, one per visualization, 5 columns)
- design/dashboard_spec.md (per-tile data content spec, chrome-free)

### Dashboards and tile counts
- Campaign Performance (explore campaign_performance, GBP): 5 KPI tiles, 4 charts, 1 table = 10 visualizations.
  KPIs: Impressions Delivered, Fill Rate (fill_rate_pct), Average CPM (cpm_gbp), Revenue Delivered, Active Campaigns.
  Charts: Impressions Delivered vs Eligible (line), Revenue Share by Advertiser (doughnut), Fill Rate by Publication (bar), Average CPM by Campaign (horizontal bar).
  Table: Campaign Performance Detail.
- Audience Engagement (explore page_engagement): 4 KPI tiles, 4 charts, 1 table = 9 visualizations.
  KPIs (R-6, exactly four): Page Views, Sessions, Unique Readers, Avg Time on Page.
  Charts: Page Views & Sessions by Day (line), Page Views by Publication (doughnut), Sessions by Publication (bar), Avg Time on Page by Section (horizontal bar).
  Table: Top Articles by Engagement.
- Total: 19 visualizations across 2 dashboards.

### Choices made on the director's behalf (round 1, no client iteration yet)
- KPI selection. SOW named delivery, fill rate, CPM for campaign performance. Added Revenue Delivered and Active Campaigns as two supporting KPIs to fill the 5-tile row and give sales context. Director to confirm or drop at review.
- Engagement measures held to exactly four per R-6 (page views, sessions, unique readers, avg time on page). No scroll depth, bounce, or device split added.
- Each dashboard is a single page with one tab. Did not split into sub-tabs for round 1 to avoid showing empty views.
- Chart type assignment: delivery trend as line; advertiser/publication shares as doughnut and bar; CPM and time-on-page rankings as horizontal bars. All swappable at review.
- Fictional names invented per R-1: advertisers (Northwind Beverages, Vellmont Motors, Harlow & Finch, Brightsail Travel, Carraway Foods, Meridian Financial, Pinevale Homes, Lumira Cosmetics); publications (The Harbour Dispatch, Metro Ledger, The Coastline Review, Evening Compass, Highgrove Weekly); plus fictional campaign and article titles. Agencies used as a filter only (names not surfaced in tiles).
- Filters chosen from available dimensions: Campaign Performance = Date Range, Advertiser, Agency, Publication, Campaign Status; Audience Engagement = Date Range, Publication, Section, Article. No device filter (not in R-6 scope).
- cpm_gbp defined as revenue_gbp / impressions_delivered x 1000; fill_rate_pct as impressions_delivered / impressions_eligible. Recorded in dashboard_spec.md measures summary for downstream confirmation.
- Avatar/approver initials set to "PS" (Priya Shah); "Prepared by Rittman Analytics" footer dated 2026-10-05.

### Scope boundary observed
- data_model_requirements.md was NOT written. It is not in this lane's Owns list, and the brief says write nothing else. The measure and dimension definitions it needs are captured in dashboard_spec.md (measures summary) and the viz catalog, ready for the data_model / viz_catalog lane to consume.

### Open questions for Priya Shah's review (mockup review round)
1. Confirm the two added Campaign Performance KPIs (Revenue Delivered, Active Campaigns), or replace with others.
2. Confirm chart types and which dimension each chart breaks down by (advertiser vs agency vs publication).
3. Confirm the Campaign Performance Detail table columns and the Top Articles table columns, and default sort.
4. Confirm filter set per dashboard (and whether agency should also appear on Audience Engagement, or a device/platform filter is wanted in a later phase).
5. Confirm whether sub-tabs (for example By Advertiser, By Publication) are wanted, or single-page is sufficient.
6. Confirm CPM and fill rate formula wording for the semantic layer.
7. R-7 deferred items (Looker access/groups, personal data, Phase 2 refresh/SLAs, seed row counts) are review-stage questions, not resolved here.

### status.md values (not written by this lane per brief; recorded here for the orchestrator)
- artifacts.mockups.generate: complete
- artifacts.mockups.review: not_started
- generated_date: 2026-10-05
- note: round 1 only; director iterates with client; mockups-review not run by this lane.

state: complete — round 1 generated: 2 dashboards, 19 visualizations, viz catalog + dashboard spec + index written. Pending director iteration and Priya Shah review.
