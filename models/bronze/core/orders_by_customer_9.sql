{{
    config(
        materialized='incremental',
        required_tests=None
    )
}}

select 
    customer_id,
    count(order_id) as num_orders
from {{ ref('fct_orders') }}
group by customer_id
