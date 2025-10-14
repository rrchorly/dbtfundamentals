{{ config(materialized="incremental", meta={'required_tests': None}) }}

SELECT
    customer_id,
    COUNT(order_id) AS num_orders
FROM {{ ref('fct_orders') }}
GROUP BY customer_id
