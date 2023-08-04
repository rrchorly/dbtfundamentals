{% snapshot orders_snapshot %}

{{
    config(
      target_database='analytics',
      target_schema= 'dbt_rrajan_snapshots',
      unique_key='id',

      strategy='timestamp',
      updated_at='_etl_loaded_at',
    )
}}

select * from {{ source('jaffle_shop', 'jaffle_shop_orders') }}

{% endsnapshot %}