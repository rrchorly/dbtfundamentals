{{
    config(
       group="customer_success"
    )
}}


select 
    amount
from {{ ref('fct_orders') }}
where amount < 0