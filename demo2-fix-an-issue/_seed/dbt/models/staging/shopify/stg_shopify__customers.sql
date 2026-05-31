-- stg_shopify__customers — Shopify customer staging layer.
-- Renames source columns to Wire conventions (_pk for primary key).

-- Note: this demo uses dbt seeds as the source data, so the staging model
-- ref()s the seed directly. A production engagement would use
-- {{ source('shopify', 'shopify_customers') }} once external ingestion lands
-- the table outside dbt.

with source as (
    select * from {{ ref('shopify_customers') }}
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
