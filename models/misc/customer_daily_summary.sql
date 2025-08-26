{{ config(meta={'required_tests': None}) }}

with orders as (
    select * from {{ ref('stg_orders') }}
),

customer_daily_summary as (
    select 
        {{ dbt_utils.generate_surrogate_key(['customer_id','order_date']) }} as id,
        customer_id,
        order_date,
        count(1) 
    from orders
    group by 1,2,3
)

select * from customer_daily_summary
