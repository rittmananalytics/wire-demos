{{
    config(
        materialized='table',
        tags=['warehouse', 'fact']
    )
}}

-- One row per campaign per day. Stores measure components only;
-- fill_rate_pct and cpm_gbp are semantic-layer calculated measures.

with

s_campaign_performance as (

    select * from {{ ref('stg_campaign_performance') }}

),

final as (

    select

        {# keys #}
        campaign_performance_pk,
        campaign_fk,
        cast(activity_date as date) as date_day,

        {# metrics #}
        impressions_delivered,
        impressions_eligible,
        revenue_gbp,

        {# temporal data types #}
        cast({{ dbt.current_timestamp() }} as {{ dbt.type_timestamp() }})
            as dbt_updated_at

    from s_campaign_performance

)

select * from final
