{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {{ log(default_schema, info=True) }}
    {{ log(custom_schema_name, info=True) }}

    {%- if custom_schema_name is none -%}

        {{ default_schema }}
    
    {% elif target.name in ['prod'] %}

        {{ custom_schema_name | trim }}

    {%- else -%}

        {{ default_schema }}_{{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}

