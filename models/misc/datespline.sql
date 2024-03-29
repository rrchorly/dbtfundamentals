
{{ config(materialized='table') }}

{%- set datepart = "day" -%}
{%- set start_date = "TO_DATE('2013/03/05', 'yyyy/mm/dd')" -%}
{%- set end_date = "dateadd(day, 5, getdate())"-%}



WITH as_of_date AS (
{{ dbt_utils.date_spine(datepart=datepart,
start_date=start_date,
end_date= end_date) }}
)


{{
    config(
       required_tests=None
    )
}}

SELECT DATE_{{datepart}} as AS_OF_DATE FROM as_of_date