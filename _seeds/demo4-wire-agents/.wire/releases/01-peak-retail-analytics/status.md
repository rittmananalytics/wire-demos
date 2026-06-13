---
release_type: full_platform
current_phase: development
---

# Release Status: 01-peak-retail-analytics

## Artifacts

```yaml
requirements:
  generate: complete
  validate: complete
  review: approved
  review_date: 2026-06-03
  reviewer: head of ecommerce + commercial director

conceptual_model:
  generate: complete
  validate: complete
  review: approved
  review_date: 2026-06-04
  reviewer: head of ecommerce + senior data analyst

pipeline_design:
  generate: complete
  validate: complete
  review: approved
  review_date: 2026-06-04
  reviewer: head of ecommerce + finance manager

data_model:
  generate: complete
  validate: complete
  review: approved
  review_date: 2026-06-05
  reviewer: senior data analyst + finance manager

dbt:
  generate: not_started
  validate: not_started
  review: not_started

semantic_layer:
  generate: not_started
  validate: not_started
  review: not_started

orchestration:
  generate: not_started
  validate: not_started
  review: not_started

dashboards:
  generate: not_started
  validate: not_started
  review: not_started
```

## Open questions

| ID | Question | Status |
|---|---|---|
| OQ-1 | Which customer ID takes precedence when Shopify and NetSuite have the same email but different IDs? | **Resolved** — Shopify ID is canonical; NetSuite ID stored as `netsuite_customer_id_fk` |
| OQ-2 | Email attribution window for Klaviyo → Shopify revenue | **Resolved** — 7-day click, 1-day open |
| OQ-3 | Wholesale orders in `orders_fct` — separate flag or separate model? | **Resolved** — `is_wholesale` flag on `orders_fct`; no separate mart for v1 |

## Agents

```yaml
mode: local
last_orchestrated: ~
paused_at: ~
```
