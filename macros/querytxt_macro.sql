{% macro querytxt_macro() %}

    delete from fct_orders_new
    where order_id not in (
        select order_id from {{ ref("stg_orders") }}
    )

{% endmacro %}
