-- stg_shopify__orders — Shopify order staging layer.
-- Renames source columns to Wire conventions (_pk for primary key, _fk for foreign key, _ts for timestamps).

-- Note: this demo uses dbt seeds as the source data, so the staging model
-- ref()s the seed directly. A production engagement would use
-- {{ source('shopify', 'shopify_orders') }} once external ingestion lands
-- the table outside dbt.

with source as (
    select * from {{ ref('shopify_orders') }}
),

renamed as (
    select
        id                  as order_pk,
        customer_id         as customer_fk,     -- correct Wire convention here
        email,
        order_number,
        financial_status,
        total_price,
        currency,
        market,
        created_at          as order_ts,
        updated_at          as updated_ts
    from source
)

select * from renamed
