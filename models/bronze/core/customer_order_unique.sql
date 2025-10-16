WITH orders AS (
    SELECT *
    FROM {{ ref('fct_orders') }}
),

customer_order_unique AS (
    SELECT MD5(customer_id || order_id) AS unique_id
    FROM orders
)

SELECT * FROM customer_order_unique
