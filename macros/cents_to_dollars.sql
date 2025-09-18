{% macro cents_to_dollars(column_name,decimal_places =2 ) -%}
    round(1.0 * {{ column_name }} /100, {{ decimal_places }})

    {% set pass_phrase = env_var('DBT_ENV_SECRET_VALUE') %}
{% endmacro %}