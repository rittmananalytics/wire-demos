{{
  config(
    description = 'Customer dimension, one row per customer'
    )
}}

with s_int_core__customer as (

    select * from {{ ref('int_core__customer') }}

),

final as (

    select
        {# keys #}
        customer_pk,
        customer_natural_key,
        {# attributes #}
        customer_email,
        customer_first_name,
        customer_last_name,
        customer_country_code,
        {# metrics #}
        customer_lifetime_order_count,
        customer_lifetime_revenue_amount,
        {# booleans #}
        has_marketing_consent,
        {# temporal data types #}
        customer_created_ts
    from s_int_core__customer

)

select * from final
