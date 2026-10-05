{{
    config(
        materialized='table',
        tags=['warehouse', 'fact']
    )
}}

-- One row per article page per day (page is the grain, no Page entity).
-- Stores total_time_on_page_seconds (numerator) and page_views
-- (denominator); the weighted average is a semantic-layer measure.
-- unique_readers is a daily per-page count; summing it gives a
-- daily-unique upper bound, not true distinct readers.

with

s_page_engagement as (

    select * from {{ ref('stg_page_engagement') }}

),

final as (

    select

        {# keys #}
        page_engagement_pk,
        content_fk,
        cast(activity_date as date) as date_day,

        {# metrics #}
        page_views,
        sessions,
        unique_readers,
        total_time_on_page_seconds,

        {# temporal data types #}
        cast({{ dbt.current_timestamp() }} as {{ dbt.type_timestamp() }})
            as dbt_updated_at

    from s_page_engagement

)

select * from final
