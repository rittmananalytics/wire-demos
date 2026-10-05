{{
    config(
        materialized='table',
        tags=['warehouse', 'dimension']
    )
}}

with

s_article as (

    select * from {{ ref('article') }}

),

final as (

    select

        {# keys #}
        {{ dbt_utils.generate_surrogate_key(['article_id']) }}
            as content_pk,
        article_id,

        {# attributes #}
        article,
        publication,
        section,
        author,

        {# temporal data types #}
        cast(publish_date as date) as publish_date,
        cast({{ dbt.current_timestamp() }} as {{ dbt.type_timestamp() }})
            as dbt_updated_at

    from s_article

)

select * from final
