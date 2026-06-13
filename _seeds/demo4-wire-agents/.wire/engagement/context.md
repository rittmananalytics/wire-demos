---
client_name: Peak Retail Group
engagement_name: peak_retail_data_foundation
release_name: Data Foundation
release_type: full_platform
warehouse: duckdb
dbt_project_path: dbt/
start_date: 2026-06-13
---

# Peak Retail Group — Engagement Context

Peak Retail Group is a UK D2C outdoor apparel retailer, £18m revenue, with a growing
subscription and replenishment model. They sell direct through Shopify, manage wholesale
inventory through NetSuite, run lifecycle comms in Klaviyo, and track paid acquisition
with GA4 + Google Ads.

## Stakeholders

- **Commercial director** — engagement sponsor, owns commercial KPIs and P&L reporting
- **Head of ecommerce** — primary requirements owner, Shopify and Klaviyo admin
- **Finance manager** — NetSuite owner, revenue reconciliation and margin reporting
- **Senior data analyst** — analyst team lead, will own the Looker instance post-handover

## Data sources

| Source | System | Connector | Contents |
|---|---|---|---|
| Shopify | Orders platform | Fivetran | orders, order_items, customers, products, refunds |
| NetSuite | ERP / inventory | Fivetran | transactions, items, customers |
| Klaviyo | Email marketing | Fivetran | events, campaigns |
| GA4 | Web analytics | BigQuery export | sessions |

For this demo all sources are represented by DuckDB seed CSVs.

## Project goals

1. Unified commercial analytics: revenue, margin, customer acquisition cost, LTV
2. Customer identity resolution across Shopify and NetSuite (distinct customer IDs)
3. Email marketing attribution: Klaviyo campaigns → Shopify orders
4. A daily-refresh executive dashboard covering revenue, customer cohorts, and channel ROI
5. A semantic layer that lets the commercial team self-serve from Looker
