with customers as (

    select
        id as customer_id,
        first_name,
        last_name,
        'TEST' as test_column, 
        'TEST2' as "test_2_column"
    from {{ source('jaffle_shop','customers') }}
)

select * from customers 