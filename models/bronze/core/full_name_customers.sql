{{
    config(
       required_tests=None
    )
}}

with customers as (
    select * from {{ ref('dim_customers') }}
),
final as (
    select customers.first_name as full_name
    from
    customers
)
select * from final