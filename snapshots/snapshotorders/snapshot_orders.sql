{% snapshot order_snapshots %}

{{
    config(
      target_schema= 'dbt_rrajan_snapshots',
      unique_key='id',

      strategy='timestamp',
      updated_at='_etl_loaded_at',
    )
}}

select * from {{ source('jaffle_shop', 'orders') }}

{% endsnapshot %}