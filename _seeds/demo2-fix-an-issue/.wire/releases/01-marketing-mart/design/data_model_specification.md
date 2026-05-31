# Data Model Specification — Marketing Mart Extension

## Layers

| Layer | Models |
|---|---|
| Staging | `stg_shopify__customers`, `stg_shopify__orders` |
| Integration | `int_orders` (Shopify orders enriched with Stripe payment status) |
| Warehouse | `dim_customer`, `fct_orders` |

## Physical ERD

```
                ┌─────────────────────┐
                │   dim_customer      │
                │   ─────────────     │
                │   customer_pk (PK)  │
                │   email             │
                │   first_name        │
                │   last_name         │
                │   country_code      │
                │   lifetime_orders   │
                │   lifetime_revenue  │
                └──────────┬──────────┘
                           │
                  customer_fk (FK)
                           │
                ┌──────────▼──────────┐
                │   fct_orders        │
                │   ─────────────     │
                │   order_pk (PK)     │
                │   customer_fk (FK)  │
                │   order_ts          │
                │   total_price       │
                │   currency          │
                │   market            │
                │   payment_status    │
                └─────────────────────┘
```

## Wire convention checklist

- PKs end `_pk` (`order_pk`, `customer_pk`) ✓
- FKs end `_fk` (`customer_fk`) ✓
- Timestamps end `_ts` (`order_ts`) ✓
- Booleans not required in this release
- Every PK has a unique + not_null test
- Every FK has a relationships test against the corresponding PK
