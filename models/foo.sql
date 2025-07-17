{{ config(materialized='table') }}
select 2 as id, 'bob' as first_name, TIMESTAMPADD(DAY, -10, CURRENT_TIMESTAMP())  as updated_at
