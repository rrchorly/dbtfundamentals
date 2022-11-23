with orders as (

    select * from {{ ref('stg_orders') }}
),

daily as (

    select 
        order_date,
        count(1) as daily_total_orders
    from orders
    group by 1
),

compared as (

    select *,
        lag(daily_total_orders) over (order by order_date) as previous_day_orders
    from daily
)

select * from  compared