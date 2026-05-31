{# Shim BigQuery's safe_cast(x AS type) → DuckDB's try_cast(x AS type) #}
{% macro safe_cast(expression, type) -%}
    try_cast({{ expression }} as {{ type }})
{%- endmacro %}
