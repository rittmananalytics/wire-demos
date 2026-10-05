{{
    config(
        materialized='table',
        tags=['warehouse', 'dimension']
    )
}}

-- Generated date spine over the seed date range (no seed file).
-- spine_start_date / spine_end_date are set in dbt_project.yml; the
-- end bound is exclusive. The calendar-part functions below
-- (dayname, isodow, monthname, date_trunc('week', ...)) are DuckDB
-- syntax. Phase 2 (BigQuery) replaces them with format_date / extract.

with

spine as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('" ~ var('spine_start_date') ~ "' as date)",
        end_date="cast('" ~ var('spine_end_date') ~ "' as date)"
    ) }}

),

final as (

    select

        {# keys #}
        cast(date_day as date) as date_day,

        {# attributes #}
        dayname(date_day) as day_of_week,
        cast(isodow(date_day) as {{ dbt.type_int() }}) as day_of_week_number,
        cast(date_trunc('week', date_day) as date) as week_start_date,
        cast(week(date_day) as {{ dbt.type_int() }}) as iso_week,
        cast(month(date_day) as {{ dbt.type_int() }}) as month,
        monthname(date_day) as month_name,
        cast(quarter(date_day) as {{ dbt.type_int() }}) as quarter,
        cast(year(date_day) as {{ dbt.type_int() }}) as year,

        {# temporal data types #}
        cast({{ dbt.current_timestamp() }} as {{ dbt.type_timestamp() }})
            as dbt_updated_at

    from spine

)

select * from final
