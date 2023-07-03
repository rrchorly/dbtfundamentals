{% set last_warehouse_query %}
    show warehouses;
    select
        query_id
    from table(information_schema.query_history())
    where 
        query_text = 'show warehouses;'
    order by 
        start_time desc
    limit 1
{% endset %}

{% set query_id = dbt_utils.get_single_value(last_warehouse_query) %}

with

final as (
    select *
    from table(result_scan('{{ query_id }}'))
)

select * from final
