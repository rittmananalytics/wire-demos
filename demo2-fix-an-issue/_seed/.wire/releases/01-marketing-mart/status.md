---
release_id: "20260415"
release_name: 01-marketing-mart
release_type: dbt_development
client_name: Acme Coffee Roasters
engagement_name: marketing_mart_extension
created_date: 2026-04-15
last_updated: 2026-04-29
current_phase: dbt_validate
---

# Release Status — 01-marketing-mart

## Artifacts

```yaml
requirements:
  generate: complete
  validate: pass
  review: approved
  file: requirements/requirements_specification.md
  generated_date: 2026-04-15
  reviewed_date: 2026-04-17
  reviewed_by: Becky Hartmann

data_model:
  generate: complete
  validate: pass
  review: approved
  file: design/data_model_specification.md
  generated_date: 2026-04-18
  reviewed_date: 2026-04-22
  reviewed_by: Steph Owens

dbt:
  generate: complete
  validate: failing                 # Wire convention violation in fct_orders.sql
  review: blocked                   # waiting on validation
  files:
    - models/staging/shopify/stg_shopify__orders.sql
    - models/staging/shopify/stg_shopify__customers.sql
    - models/integration/int_orders.sql
    - models/warehouse/dim_customer.sql
    - models/warehouse/fct_orders.sql
  generated_date: 2026-04-25
  last_validation_failure: 2026-04-29
```

## Session History

| Date | Accomplished | Suggested Next |
|------|-------------|----------------|
| 2026-04-15 | Engagement created (type: dbt_development) | Generate requirements |
| 2026-04-17 | Requirements generated, validated, reviewed and approved | Generate data model |
| 2026-04-22 | Data model generated, validated, reviewed and approved | Generate dbt models |
| 2026-04-25 | dbt models generated for staging + integration + warehouse layers | Run dbt-validate |
| 2026-04-29 | **dbt-validate FAILED** — naming convention violation in fct_orders.sql (`customer_id` should be `customer_fk` per Wire convention) | Fix the FK column name and re-validate |

## Notes
- Build is otherwise clean: `dbt build` runs green; only the Wire naming convention is violated.
- This is the state the Demo 2 inherits.
