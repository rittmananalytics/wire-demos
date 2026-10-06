# Data Model Specification — Marketing Mart Extension

## Layers

| Layer | Models |
|---|---|
| Staging | `stg_shopify__customer`, `stg_shopify__order` |
| Integration | `int_core__customer` (customers with lifetime order count and revenue), `int_core__order` (orders with customer country and marketing consent) |
| Warehouse | `wh_core__customer_dim`, `wh_core__order_fact` |

Folders follow Wire's layout: `staging/stg_shopify/`, `integration/int_core/`,
`warehouse/wh_core/`. Tests and descriptions live in `models/schema.yml`, with
column descriptions as doc blocks in `models/field_descriptions.md`.

## Physical ERD

```
        ┌──────────────────────────────────┐
        │   wh_core__customer_dim          │
        │   ─────────────────────          │
        │   customer_pk (PK)               │
        │   customer_natural_key           │
        │   customer_email                 │
        │   customer_first_name            │
        │   customer_last_name             │
        │   customer_country_code          │
        │   customer_lifetime_order_count  │
        │   customer_lifetime_revenue_amount│
        │   has_marketing_consent          │
        │   customer_created_ts            │
        └────────────────┬─────────────────┘
                         │
                customer_fk (FK)
                         │
        ┌────────────────▼─────────────────┐
        │   wh_core__order_fact            │
        │   ─────────────────────          │
        │   order_pk (PK)                  │
        │   customer_fk (FK)               │
        │   order_natural_key              │
        │   order_number                   │
        │   order_payment_status           │
        │   order_currency_code            │
        │   order_market                   │
        │   customer_country_code          │
        │   order_total_amount             │
        │   has_customer_marketing_consent │
        │   order_created_ts               │
        └──────────────────────────────────┘
```

## Wire convention checklist

- Model names are singular and follow `<layer>_<group>__<entity>`
- PKs and FKs are built with `dbt_utils.generate_surrogate_key`; Shopify IDs are kept as `_natural_key`
- Money columns end `_amount`, timestamps end `_ts`, booleans start `has_`
- Every PK has a unique + not_null test
- Every FK has a relationships test against the corresponding PK
- Every warehouse column is described
