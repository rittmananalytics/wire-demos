# Conceptual Model — Peak Retail Data Foundation

**Status**: Approved 2026-06-04

## Entities and relationships

```
Shopify Customer ──┐
                   ├──▶ int__customer_unified (canonical identity)
NetSuite Customer ─┘         │
                              │
                              ▼
Shopify Order ───────────▶ orders_fct ◀─── int__order_financial
Shopify Order Item ───────▶ order_items_fct
Shopify Refund ────────────▶ (refund flag on orders_fct)
                              │
                              ▼
                          daily_revenue_fct
                          customer_ltv_fct
                          
Klaviyo Campaign ────────▶ int__marketing_attribution ──▶ email_performance_fct
Klaviyo Event ───────────▶ int__marketing_attribution     marketing_spend_fct

GA4 Session ─────────────▶ int__marketing_attribution

NetSuite Transaction ─────▶ int__order_financial ──▶ orders_fct
NetSuite Item ────────────▶ product_dim
```

## Grain definitions

| Model | Grain |
|---|---|
| `orders_fct` | One row per Shopify order |
| `order_items_fct` | One row per order line item |
| `daily_revenue_fct` | One row per day × channel |
| `customer_ltv_fct` | One row per customer (cumulative, snapshot) |
| `email_performance_fct` | One row per Klaviyo campaign × send date |
| `marketing_spend_fct` | One row per channel × day (stub for v1 — spend data TBC) |

## Dimensions

| Dimension | Source |
|---|---|
| `customer_dim` | int__customer_unified (Shopify canonical + NetSuite attributes) |
| `product_dim` | Shopify products + NetSuite items |
| `channel_dim` | Seed — canonical channel taxonomy (direct, email, wholesale, organic) |
