with dim_customers as (

    select * from {{ ref('dim_customers') }}
),
orders_by_customer_first_name as (

    select 
        first_name,
        sum(number_of_orders) from dim_customers group by first_name order by 1

)
select * from orders_by_customer_first_name