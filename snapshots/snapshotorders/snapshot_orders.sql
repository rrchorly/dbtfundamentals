{% snapshot order_snapshots %}

{{
    config(
      alias='rrajan_snapshots',
      target_schema= 'dbt_rrajan_snapshots',
      unique_key='id',
      strategy='check',
      check_cols='all'
    )
}}

select * from {{ source('jaffle_shop', 'jaffle_shop_orders') }}

{% endsnapshot %}