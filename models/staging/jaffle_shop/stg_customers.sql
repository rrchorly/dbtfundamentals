with customers as (

    select
        id as customer_id,
        first_name,
<<<<<<< HEAD
        last_name,
        'TEST' as test_column, 
        'TEST2' as "test_2_column"
    from {{ source('jaffle_shop','customers') }}
=======
        last_name
   -- from {{ source('jaffle_shop','jaffle_shop_customers') }}
    from jaffle_shop_customers
>>>>>>> 5d8963fb0455a08e352658268f82d1dfa9cbc396
)

select * from customers 