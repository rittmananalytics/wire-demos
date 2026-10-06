{{
  config(
    description = 'Shopify orders, one row per order, renamed and cast'
    )
}}

-- This demo loads the Shopify extract as dbt seeds, so staging reads the
-- seed with ref(). A production project reads it with source().

with s_shopify_orders as (

    select * from {{ ref('shopify_orders') }}

),

rename_and_cast as (

    select

        {# keys #}
        {{ dbt_utils.generate_surrogate_key(['id']) }} as order_pk,
        {{ dbt_utils.generate_surrogate_key(['customer_id']) }}
            as customer_fk,
        cast(id as {{ dbt.type_string() }}) as order_natural_key,
        {# attributes #}
        cast(order_number as {{ dbt.type_string() }}) as order_number,
        cast(email as {{ dbt.type_string() }}) as order_email,
        cast(financial_status as {{ dbt.type_string() }})
            as order_payment_status,
        cast(currency as {{ dbt.type_string() }}) as order_currency_code,
        cast(market as {{ dbt.type_string() }}) as order_market,
        {# metrics #}
        cast(total_price as {{ dbt.type_numeric() }}) as order_total_amount,
        {# temporal data types #}
        cast(created_at as {{ dbt.type_timestamp() }}) as order_created_ts,
        cast(updated_at as {{ dbt.type_timestamp() }}) as order_updated_ts

    from s_shopify_orders

),

final as (

    select * from rename_and_cast

)

select * from final
