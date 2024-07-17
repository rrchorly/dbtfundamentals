{{
    config(
        post_hook="{{update_mart_audit_table(22,'post')}}"
    )
}}


with 
    customers as (

    select * from {{ ref('dim_customers') }} 
    )

select * from customers