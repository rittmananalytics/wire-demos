{{
  config(
    description = 'Customers with lifetime order count and revenue'
    )
}}

with s_stg_shopify__customer as (

    select * from {{ ref('stg_shopify__customer') }}

),

s_stg_shopify__order as (

    select * from {{ ref('stg_shopify__order') }}

),

customer_order_summary as (

    select
        customer_fk,
        count(*) as customer_lifetime_order_count,
        sum(order_total_amount) as customer_lifetime_revenue_amount
    from s_stg_shopify__order
    group by customer_fk

),

final as (

    select
        {# keys #}
        s_stg_shopify__customer.customer_pk,
        s_stg_shopify__customer.customer_natural_key,
        {# attributes #}
        s_stg_shopify__customer.customer_email,
        s_stg_shopify__customer.customer_first_name,
        s_stg_shopify__customer.customer_last_name,
        s_stg_shopify__customer.customer_country_code,
        {# metrics #}
        coalesce(
            customer_order_summary.customer_lifetime_order_count, 0
        ) as customer_lifetime_order_count,
        coalesce(
            customer_order_summary.customer_lifetime_revenue_amount, 0
        ) as customer_lifetime_revenue_amount,
        {# booleans #}
        s_stg_shopify__customer.has_marketing_consent,
        {# temporal data types #}
        s_stg_shopify__customer.customer_created_ts
    from s_stg_shopify__customer
    left join customer_order_summary
        on s_stg_shopify__customer.customer_pk
            = customer_order_summary.customer_fk

)

select * from final
