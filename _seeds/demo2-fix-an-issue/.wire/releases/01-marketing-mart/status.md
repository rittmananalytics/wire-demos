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
  validate: failing                 # order fact customer_fk has no FK test
  review: blocked                   # waiting on validation
  files:
    - models/staging/stg_shopify/stg_shopify__customer.sql
    - models/staging/stg_shopify/stg_shopify__order.sql
    - models/integration/int_core/int_core__customer.sql
    - models/integration/int_core/int_core__order.sql
    - models/warehouse/wh_core/wh_core__customer_dim.sql
    - models/warehouse/wh_core/wh_core__order_fact.sql
    - models/schema.yml
    - models/field_descriptions.md
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
| 2026-04-29 | **dbt-validate FAILED**: wh_core__order_fact.customer_fk is undocumented in models/schema.yml and has no relationships test against wh_core__customer_dim.customer_pk (Wire convention requires both) | Update schema.yml and re-validate |

## Notes
- Build is otherwise clean: `dbt build` runs green.
