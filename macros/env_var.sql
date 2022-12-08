{% macro env_var() %}
    {{ env_var('DBT_ENV_SECRET_VALUE') }}
{% endmacro %}