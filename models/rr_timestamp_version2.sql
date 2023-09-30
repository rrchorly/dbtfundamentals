with rr_timestamp as (

    select updated_at,
    to_timestamp_tz(

                convert_timezone('Australia/Brisbane', current_timestamp())

            ) as updated_at_2
    from analytics.dbt_rrajan.rr_timestamp
)

select * from rr_timestamp