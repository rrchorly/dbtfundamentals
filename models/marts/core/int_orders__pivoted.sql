
with payments as (
    select * from {{ ref('stg_payments') }}
),

pivoted as (
    select * from payments
)

select * from pivoted


