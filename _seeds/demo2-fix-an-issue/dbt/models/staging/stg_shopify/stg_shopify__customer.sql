{{
  config(
    description = 'Shopify customers, one row per customer, renamed and cast'
    )
}}

-- This demo loads the Shopify extract as dbt seeds, so staging reads the
-- seed with ref(). A production project reads it with source().

with s_shopify_customers as (

    select * from {{ ref('shopify_customers') }}

),

rename_and_cast as (

    select

        {# keys #}
        {{ dbt_utils.generate_surrogate_key(['id']) }} as customer_pk,
        cast(id as {{ dbt.type_string() }}) as customer_natural_key,
        {# attributes #}
        cast(email as {{ dbt.type_string() }}) as customer_email,
        cast(first_name as {{ dbt.type_string() }}) as customer_first_name,
        cast(last_name as {{ dbt.type_string() }}) as customer_last_name,
        cast(country_code as {{ dbt.type_string() }})
            as customer_country_code,
        {# booleans #}
        cast(accepts_marketing as {{ dbt.type_boolean() }})
            as has_marketing_consent,
        {# temporal data types #}
        cast(created_at as {{ dbt.type_timestamp() }}) as customer_created_ts,
        cast(updated_at as {{ dbt.type_timestamp() }}) as customer_updated_ts

    from s_shopify_customers

),

final as (

    select * from rename_and_cast

)

select * from final
