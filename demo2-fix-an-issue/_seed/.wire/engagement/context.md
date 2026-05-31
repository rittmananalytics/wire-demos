---
engagement_name: marketing_mart_extension
client_name: Acme Coffee Roasters
created_date: 2026-04-15
engagement_lead: Mark Rittman
repo_mode: combined
---

# Engagement Context — marketing_mart_extension

## Client
**Name**: Acme Coffee Roasters Ltd
**Sponsor**: Becky Hartmann — Head of Data
**Engagement Lead**: Mark Rittman (RA)

## Objective
Extend the existing Acme data warehouse with a marketing attribution mart joining Klaviyo + GA4 events to Stripe revenue. Builds on the foundation release delivered in Q1 2026 (Shopify + Stripe staging and warehouse layers are already in place).

## Releases
- `01-marketing-mart` — current release, dbt_development. Adding `fct_orders` mart with customer attribution joins.

## Repo Mode
Combined — `.wire/` lives directly in the client's dbt repo alongside `dbt/`.
