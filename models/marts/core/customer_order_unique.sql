with orders as (
    select 
    *
    from {{ ref('fct_orders') }}
),

customer_order_unique as (
    select 
    md5(customer_id || order_id ) as unique_id 
    from orders
)
   
select * from customer_order_unique