{{
    config(
        materialized='table',
        tags=['warehouse', 'dimension']
    )
}}

with

s_campaign as (

    select * from {{ ref('campaign') }}

),

final as (

    select

        {# keys #}
        {{ dbt_utils.generate_surrogate_key(['campaign_id']) }}
            as campaign_pk,
        campaign_id,

        {# attributes #}
        campaign,
        advertiser,
        agency,
        campaign_status,
        publication,

        {# metrics #}
        cast(booked_impression_goal as {{ dbt.type_int() }})
            as booked_impression_goal,
        cast(rate_card_cpm_gbp as {{ dbt.type_numeric() }})
            as rate_card_cpm_gbp,

        {# temporal data types #}
        cast(booking_start_date as date) as booking_start_date,
        cast(booking_end_date as date) as booking_end_date,
        cast({{ dbt.current_timestamp() }} as {{ dbt.type_timestamp() }})
            as dbt_updated_at

    from s_campaign

)

select * from final
