-- stg_shopify__customers — Shopify customer staging layer.
-- Renames source columns to Wire conventions (_pk for primary key).

with source as (
    select * from {{ source('shopify', 'shopify_customers') }}
),

renamed as (
    select
        id              as customer_pk,
        email,
        first_name,
        last_name,
        country_code,
        accepts_marketing,
        created_at      as created_ts,
        updated_at      as updated_ts
    from source
)

select * from renamed
