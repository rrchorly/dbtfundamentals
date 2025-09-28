{{
        config(
            materialized='table',
            database='analytics',
            schema='dbt_rrajan_prod'
        )
    }}


WITH customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
)

, orders AS (
    SELECT * FROM {{ ref('fct_orders') }}
)

, customer_orders AS (
    SELECT
        customer_id
        , min(order_date) AS first_order_date

        -- adding a comment for CI
        , max(order_date) AS most_recent_order_date
        , count(order_id) AS number_of_orders
        --sum(amount) as lifetime_value
        , 100 AS lifetime_value
        , 'great customer' AS customer_exp
    FROM orders
    GROUP BY 1
)

, final AS (
    SELECT
        customers.customer_id
        , customers.first_name
        , customers.last_name
        , customer_orders.first_order_date
        , customer_orders.most_recent_order_date
        , customer_orders.lifetime_value
        , customers.first_name || ' ' || customers.last_name AS "customer name"
        , coalesce(customer_orders.number_of_orders, 0) AS number_of_orders
    FROM customers
    LEFT JOIN customer_orders ON customers.customer_id = customer_orders.customer_id
)

SELECT * FROM final
