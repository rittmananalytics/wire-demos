-- fct_orders — order fact table.
--
-- NOTE FOR THE DEMO: this model contains a deliberate Wire-convention violation.
-- The foreign key to dim_customer is named `customer_id` rather than `customer_fk`.
-- Wire's dbt-development convention requires foreign keys to end in `_fk`.
-- /wire:dbt-validate should flag this; Demo 2's fix step renames the column.

with orders as (
    select * from {{ ref('int_orders') }}
),

final as (
    select
        order_pk,
        customer_fk         as customer_id,        -- ← VIOLATION: should remain customer_fk per Wire convention
        order_ts,
        total_price,
        currency,
        market,
        payment_status,
        customer_country_code,
        customer_accepts_marketing
    from orders
)

select * from final
