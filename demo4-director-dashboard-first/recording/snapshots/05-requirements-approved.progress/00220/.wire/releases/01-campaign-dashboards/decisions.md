# Decisions: 01-campaign-dashboards

Rulings by the release director, recorded when made.

| ID | Date | By | Ruling | Applies to |
|----|------|----|--------|------------|
| R-1 | 2026-10-05 | Mark Rittman | All sample data uses made-up advertiser and publication names. No real brands, agencies or titles. | mockups, viz_catalog, seed_data, dashboards, and any lane that writes sample data |
| R-2 | 2026-10-05 | Mark Rittman | Release type `dashboard_first`, profile `seeded`. Reason: SOW requires approved mockups before build and uses seed data; live GAM and GA4 data is Phase 2. | release |
| R-3 | 2026-10-05 | Mark Rittman | Not planned, per SOW scope: business_rules, workshops, logical_model, dbtcharts, agents_schema, training, documentation. No pipeline work. | release |
| R-4 | 2026-10-05 | Mark Rittman | No Jira, Linear, document store or Fathom call sync. Every step runs as a lane visible in Wire Studio. | release |
| R-5 | 2026-10-05 | Mark Rittman | Requirements approved by Priya Shah, Commercial Director, Claybrook Media Group. She is also the approver for the mockups. | requirements, mockups |
| R-6 | 2026-10-05 | Mark Rittman | Audience engagement measures are page views, sessions, unique readers and average time on page. Resolves requirements FR-3 open question. | mockups, viz_catalog, data_model, seed_data, semantic_layer |
| R-7 | 2026-10-05 | Mark Rittman | Remaining open requirements questions (Looker access, personal data, Phase 2 refresh and service levels, seed row counts) deferred to the mockup review. | mockups review |
