-- dim_customer — customer dimension with lifetime aggregates joined in from orders.

with customers as (
    select * from {{ ref('stg_shopify__customers') }}
),

orders_agg as (
    select
        customer_fk,
        count(*)             as lifetime_orders,
        sum(total_price)     as lifetime_revenue
    from {{ ref('stg_shopify__orders') }}
    group by 1
),

joined as (
    select
        c.customer_pk,
        c.email,
        c.first_name,
        c.last_name,
        c.country_code,
        c.accepts_marketing,
        coalesce(o.lifetime_orders, 0)   as lifetime_orders,
        coalesce(o.lifetime_revenue, 0)  as lifetime_revenue,
        c.created_ts
    from customers c
    left join orders_agg o on c.customer_pk = o.customer_fk
)

select * from joined
