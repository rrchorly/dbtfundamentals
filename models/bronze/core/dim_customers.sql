    {{
        config(
            materialized='table',
            database='analytics',
            schema='dbt_rrajan_prod'
        )
    }}
    
    
    with customers as (
    select * from {{ ref('stg_customers')}}
),
orders as (
    select * from {{ ref('fct_orders')}}
),
customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,

        -- adding a comment for CI
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
       --sum(amount) as lifetime_value
        100 as lifetime_value,
        'great customer' customer_exp
    from orders
    group by 1
),
final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customers.first_name||' '||customers.last_name as "customer name",
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        customer_orders.lifetime_value
    from customers
    left join customer_orders using (customer_id)
)
select * from final