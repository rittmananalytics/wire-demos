-- int_orders — combines Shopify orders with derived attributes used by downstream marts.

with orders as (
    select * from {{ ref('stg_shopify__orders') }}
),

customers as (
    select * from {{ ref('stg_shopify__customers') }}
),

enriched as (
    select
        o.order_pk,
        o.customer_fk,
        o.order_ts,
        o.total_price,
        o.currency,
        o.market,
        o.financial_status                          as payment_status,
        c.country_code                              as customer_country_code,
        c.accepts_marketing                         as customer_accepts_marketing
    from orders o
    left join customers c on o.customer_fk = c.customer_pk
)

select * from enriched
