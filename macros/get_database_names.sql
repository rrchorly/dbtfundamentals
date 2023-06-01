{% macro get_database_names(prefix) %}
    {% set database_names = [] %}

    {% if prefix is not defined or prefix|length == 0 %}
        {% set prefix = "DEV" %}
    {% endif %}

    {% set database_names_query %}
        SELECT database_name AS database_name
        FROM {{ prefix }}_S_SALESFORCE.INFORMATION_SCHEMA.DATABASES
        WHERE STARTSWITH(database_name, '{{ prefix }}')  
        AND NOT ENDSWITH(database_name, 'EDW')
        AND NOT ENDSWITH(database_name, 'MARTS')
    {% endset %}

    {% set results = run_query(database_names_query) %}

    {% if execute %}
        {% set database_names = results.columns[0].values() %}
    {% else %}
        {% set database_names = [] %}
    {% endif %}

    {{ return(database_names) }}

{%- endmacro %}