{{
    config(
        materialized='view',
        tags=['staging', 'campaign']
    )
}}

with

s_campaign_performance as (

    select * from {{ ref('campaign_performance') }}

),

rename_and_cast as (

    select

        {# keys #}
        campaign_id,

        {# metrics #}
        cast(impressions_delivered as {{ dbt.type_int() }})
            as impressions_delivered,
        cast(impressions_eligible as {{ dbt.type_int() }})
            as impressions_eligible,
        cast(revenue_gbp as {{ dbt.type_numeric() }}) as revenue_gbp,

        {# temporal data types #}
        cast(date as date) as activity_date

    from s_campaign_performance

),

final as (

    select

        {# keys #}
        {{ dbt_utils.generate_surrogate_key([
            'campaign_id', 'activity_date'
        ]) }} as campaign_performance_pk,
        {{ dbt_utils.generate_surrogate_key(['campaign_id']) }}
            as campaign_fk,
        campaign_id,

        {# metrics #}
        impressions_delivered,
        impressions_eligible,
        revenue_gbp,

        {# temporal data types #}
        activity_date

    from rename_and_cast

)

select * from final
