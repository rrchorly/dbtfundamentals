{% macro get_source_system_id(source_system_name) -%}
    
    {%- set source_system_query %}
        SELECT source_system_id 
        FROM {{ source('edw_icim_prod', 'dim_source_system') }}  --dim_source_system is a static table that was built in Snowflake.  When new sources are added or end dated, the script is done directly on Snowflake.  We can not have it built in dbt because we do not want it ever rebuilt, so do not want it in dbt's run dependencies.
        WHERE source_system_name='{{ source_system_name }}'
    {% endset -%}

    {%- set result = run_query(source_system_query) -%}

    {%- if execute %}
        {%- set source_system_id = result.rows[0][0] -%}
    {% else %}
        {%- set source_system_id = 999 -%}
    {% endif -%}

    {{ return(source_system_id) }}

{%- endmacro %}