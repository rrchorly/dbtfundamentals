with labs as (

    select
        patient_id,
        panel,
        test,
        test_units,
        test_date,
        test_result

    from {{ source('healthlabs','labs') }}

)

select * from labs