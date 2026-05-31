{# Shim BigQuery's date_diff(d1, d2, day|week|month|year) → DuckDB arithmetic #}
{% macro date_diff(d1, d2, unit) -%}
    {%- if unit | lower == 'day' -%}
        (cast({{ d1 }} as date) - cast({{ d2 }} as date))
    {%- elif unit | lower == 'week' -%}
        ((cast({{ d1 }} as date) - cast({{ d2 }} as date)) / 7)
    {%- elif unit | lower == 'month' -%}
        ((extract(year from {{ d1 }}) - extract(year from {{ d2 }})) * 12 +
         (extract(month from {{ d1 }}) - extract(month from {{ d2 }})))
    {%- elif unit | lower == 'year' -%}
        (extract(year from {{ d1 }}) - extract(year from {{ d2 }}))
    {%- else -%}
        {{ exceptions.raise_compiler_error("date_diff shim: unsupported unit " ~ unit) }}
    {%- endif -%}
{%- endmacro %}
