{{
  config(
    description = 'Orders with the ordering customer country and consent'
    )
}}

with s_stg_shopify__order as (

    select * from {{ ref('stg_shopify__order') }}

),

s_stg_shopify__customer as (

    select * from {{ ref('stg_shopify__customer') }}

),

final as (

    select
        {# keys #}
        s_stg_shopify__order.order_pk,
        s_stg_shopify__order.customer_fk,
        s_stg_shopify__order.order_natural_key,
        {# attributes #}
        s_stg_shopify__order.order_number,
        s_stg_shopify__order.order_payment_status,
        s_stg_shopify__order.order_currency_code,
        s_stg_shopify__order.order_market,
        s_stg_shopify__customer.customer_country_code,
        {# metrics #}
        s_stg_shopify__order.order_total_amount,
        {# booleans #}
        s_stg_shopify__customer.has_marketing_consent
            as has_customer_marketing_consent,
        {# temporal data types #}
        s_stg_shopify__order.order_created_ts
    from s_stg_shopify__order
    left join s_stg_shopify__customer
        on s_stg_shopify__order.customer_fk
            = s_stg_shopify__customer.customer_pk

)

select * from final
