with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

customer_orders as (
    select 
 {#
        customers.customer_id as customer_id,
        customers.first_name as first_name,
        customers.last_name as last_name,
        orders.order_id as order_id,
        orders.order_date as order_date,
        orders.status as status
         #}
    count(*)
    from customers 
    left join orders using (customer_id)
)

select * from customer_orders