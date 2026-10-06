{{
  config(
    description = 'Order fact, one row per Shopify order'
    )
}}

with s_int_core__order as (

    select * from {{ ref('int_core__order') }}

),

final as (

    select
        {# keys #}
        order_pk,
        customer_fk,
        order_natural_key,
        {# attributes #}
        order_number,
        order_payment_status,
        order_currency_code,
        order_market,
        customer_country_code,
        {# metrics #}
        order_total_amount,
        {# booleans #}
        has_customer_marketing_consent,
        {# temporal data types #}
        order_created_ts
    from s_int_core__order

)

select * from final
