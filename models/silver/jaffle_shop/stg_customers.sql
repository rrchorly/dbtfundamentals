WITH customers AS (

    SELECT
        id AS customer_id,
        first_name,
        last_name
    FROM {{ source('jaffle_shop','customers') }}
)

-- {{ dbt_version }}
SELECT * FROM customers
