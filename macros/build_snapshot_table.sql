{% macro build_snapshot_table(strategy, sql) %}

    select *,

        {{ strategy.scd_id }} as dbt_scd_id,

        {{ strategy.updated_at }} as dbt_updated_at,

        {{ strategy.updated_at }} as dbt_valid_from,

        to_TIMESTAMP('9999-12-31 00:00:00.000') as dbt_valid_to

    from (

        {{ sql }}

    ) sbq

{% endmacro %}