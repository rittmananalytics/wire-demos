{{
    config(
        materialized='view',
        tags=['staging', 'content']
    )
}}

with

s_page_engagement as (

    select * from {{ ref('page_engagement') }}

),

rename_and_cast as (

    select

        {# keys #}
        article_id,

        {# metrics #}
        cast(page_views as {{ dbt.type_int() }}) as page_views,
        cast(sessions as {{ dbt.type_int() }}) as sessions,
        cast(unique_readers as {{ dbt.type_int() }}) as unique_readers,
        cast(total_time_on_page_seconds as {{ dbt.type_int() }})
            as total_time_on_page_seconds,

        {# temporal data types #}
        cast(date as date) as activity_date

    from s_page_engagement

),

final as (

    select

        {# keys #}
        {{ dbt_utils.generate_surrogate_key([
            'article_id', 'activity_date'
        ]) }} as page_engagement_pk,
        {{ dbt_utils.generate_surrogate_key(['article_id']) }}
            as content_fk,
        article_id,

        {# metrics #}
        page_views,
        sessions,
        unique_readers,
        total_time_on_page_seconds,

        {# temporal data types #}
        activity_date

    from rename_and_cast

)

select * from final
