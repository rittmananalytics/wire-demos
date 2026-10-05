# Lane: mockups-round-2

Release: 01-campaign-dashboards
Task: /wire:mockups-generate 01-campaign-dashboards (round 2, apply R-9; keep R-10)
Owns: .wire/releases/01-campaign-dashboards/design/mockups/, .wire/releases/01-campaign-dashboards/design/dashboard_visualization_catalog.csv, .wire/releases/01-campaign-dashboards/design/dashboard_spec.md, .wire/releases/01-campaign-dashboards/lanes/mockups-round-2.md
Dispatched: 2026-10-05 20:20 by orchestrator [910893ca]

## Items
- [x] Average CPM as weekly trend line (Campaign Performance)
- [x] Campaign Performance Detail table to bottom of page
- [x] viz catalog, dashboard spec and index updated to match

## Results

Files changed:
- design/mockups/campaign-performance.html: "Average CPM by Campaign" horizontal bar replaced by "Average CPM by Week" line chart (cpm_gbp, weekly Wk 1-Wk 5, GBP, values 7.05/6.95/6.80/6.70/6.60 averaging £6.82 to match the headline Average CPM); "Campaign Performance Detail" table moved to the bottom of the page, full width, below all charts.
- design/dashboard_visualization_catalog.csv: CPM row now "Campaign Performance,Average CPM by Week,line,cpm_gbp,date (week)". Header unchanged. Row order already matched the new layout (table last).
- design/dashboard_spec.md: Campaign Performance visualization 9 updated to the weekly CPM line; table description and interaction note record the bottom-of-page placement.
- design/mockups/mockups_index.md: round 2 noted with its changes; Campaign Performance chart/table lines updated; status set to round 2.

Audience Engagement: no change made. Its "Top Articles by Engagement" table sits in the MIDDLE of the page, between the first chart row (Page Views & Sessions by Day, Page Views by Publication) and the second chart row (Sessions by Publication, Avg Time on Page by Section). It is NOT at the bottom. Reported for the director to raise with Priya.

Visualization counts (unchanged by the swap):
- Campaign Performance: 5 KPI tiles, 4 charts (2 line, 1 doughnut, 1 bar), 1 table.
- Audience Engagement: 4 KPI tiles, 4 charts (1 line, 1 doughnut, 1 bar, 1 horizontal bar), 1 table.

Parse checks: both HTML files have balanced div tags (campaign-performance 130/130, audience-engagement 119/119); 4 canvas and 4 new Chart() calls each. No em-dashes in any owned file. Made-up names only (R-1).

state: complete - round 2 applied to Campaign Performance (CPM weekly line, table to bottom); catalog, spec and index updated; Audience Engagement table position reported, not moved.
