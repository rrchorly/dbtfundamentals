{{ config(meta={'required_tests': None}) }}

{{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2022-01-01' as date)",
    end_date="dateadd(week,1,current_date)"
   )
}}
