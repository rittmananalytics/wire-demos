-- stg_shopify__orders — Shopify order staging layer.
-- Renames source columns to Wire conventions (_pk for primary key, _fk for foreign key, _ts for timestamps).

with source as (
    select * from {{ source('shopify', 'shopify_orders') }}
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
