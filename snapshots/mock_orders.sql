{% snapshot mock_orders %}

{% set new_schema = target.schema + '_snapshots' %}

{{
    config(
      target_database='analytics',
      target_schema=new_schema,
      unique_key='order_id',

      strategy='timestamp',
      updated_at='updated_at'
    )
}}

select * from analytics.{{target.schema}}.mock_orders

{% endsnapshot %}