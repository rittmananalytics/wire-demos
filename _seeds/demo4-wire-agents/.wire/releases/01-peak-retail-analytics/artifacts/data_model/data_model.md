# Data Model — Peak Retail Data Foundation

**Status**: Approved 2026-06-05

## Model inventory

### Staging layer (11 models)

| Model | Source table | Key columns |
|---|---|---|
| `stg_shopify__orders` | shopify_orders | order_id_pk, customer_id_fk, created_at_ts, total_amount, financial_status, is_wholesale |
| `stg_shopify__order_items` | shopify_order_items | order_item_id_pk, order_id_fk, product_id_fk, quantity, unit_price |
| `stg_shopify__customers` | shopify_customers | customer_id_pk, email, created_at_ts, total_spent, orders_count |
| `stg_shopify__products` | shopify_products | product_id_pk, title, product_type, vendor, status |
| `stg_shopify__refunds` | shopify_refunds | refund_id_pk, order_id_fk, created_at_ts, refund_amount |
| `stg_netsuite__transactions` | netsuite_transactions | transaction_id_pk, shopify_order_id_fk, amount, transaction_date_ts, type |
| `stg_netsuite__items` | netsuite_items | item_id_pk, sku, description, category, unit_cost |
| `stg_netsuite__customers` | netsuite_customers | netsuite_customer_id_pk, email, shopify_customer_id_fk |
| `stg_klaviyo__events` | klaviyo_events | event_id_pk, person_id_fk, campaign_id_fk, event_type, occurred_at_ts |
| `stg_klaviyo__campaigns` | klaviyo_campaigns | campaign_id_pk, name, subject, sent_at_ts, send_count |
| `stg_ga4__sessions` | ga4_sessions | session_id_pk, user_pseudo_id, session_start_ts, channel_grouping, source, medium |

### Integration layer (3 models)

| Model | Depends on | Purpose |
|---|---|---|
| `int__customer_unified` | stg_shopify__customers, stg_netsuite__customers | Canonical customer with Shopify ID + NetSuite reference |
| `int__order_financial` | stg_shopify__orders, stg_netsuite__transactions | Orders with NetSuite-reconciled revenue; `has_netsuite_match` flag |
| `int__marketing_attribution` | stg_klaviyo__events, stg_klaviyo__campaigns, stg_shopify__orders | Attributed revenue per campaign within 7-day click / 1-day open window |

### Warehouse layer (9 models)

| Model | Depends on | Materialisation |
|---|---|---|
| `customer_dim` | int__customer_unified | table |
| `product_dim` | stg_shopify__products, stg_netsuite__items | table |
| `channel_dim` | seed: channel_types | table |
| `orders_fct` | int__order_financial, customer_dim, product_dim | incremental (merge) |
| `order_items_fct` | stg_shopify__order_items, orders_fct | incremental (merge) |
| `daily_revenue_fct` | orders_fct | incremental (merge) |
| `email_performance_fct` | int__marketing_attribution, stg_klaviyo__campaigns | table |
| `marketing_spend_fct` | channel_dim (stub — spend data TBC) | table |
| `customer_ltv_fct` | orders_fct, customer_dim | table |

### Seeds (2)

| Seed | Rows | Purpose |
|---|---|---|
| `channel_types` | 4 | Canonical channel taxonomy: direct, email, wholesale, organic |
| `product_categories` | 6 | Canonical category taxonomy: jackets, footwear, base_layer, accessories, equipment, other |

## Surrogate key strategy

All surrogate keys generated via `dbt_utils.generate_surrogate_key()`. Natural keys preserved as `_pk` columns. All FK references use `_fk` suffix.

## Incremental strategy

Fact tables use `merge` strategy with `unique_key = <grain>_pk`. Full refresh is safe for dim tables at current row counts.
