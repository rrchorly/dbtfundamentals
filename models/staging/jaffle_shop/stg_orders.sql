with orders as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    --from {{ source('jaffle_shop','jaffle_shop_orders') }}
    from jaffle_shop_orders

)

<<<<<<< HEAD
select * from orders

{{ limit_data_in_default('order_date',2000) }}   
=======
select * from orders
>>>>>>> 5d8963fb0455a08e352658268f82d1dfa9cbc396
