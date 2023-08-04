with orders as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from {{ source('jaffle_shop','jaffle_shop_orders') }}

)

select * from orders

{{ limit_data_in_default('order_date',2000) }}   