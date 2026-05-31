-- fct_orders — order fact table.
-- One row per Shopify order, attributed to a customer via customer_fk.

with orders as (
    select * from {{ ref('int_orders') }}
),

final as (
    select
        order_pk,
        customer_fk,
        order_ts,
        total_price,
        currency,
        market,
        payment_status,
        customer_country_code,
        customer_accepts_marketing
    from orders
)

select * from final
