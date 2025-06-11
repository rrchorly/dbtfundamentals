   -- adding a comment to trigger CI 2
   -- adding new comment
with orders as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status
    from {{ source('jaffle_shop','orders') }}
)

select * from orders

{{ limit_data_in_default('order_date',3000) }}
