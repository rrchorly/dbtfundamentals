{% macro dummy_macro(something, anything) -%}
{%- set base_model_sql -%}
source_id as hallo
{%- endset %}

{% do return(base_model_sql) %}

{%- endmacro %}