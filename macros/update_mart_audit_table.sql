{% macro update_mart_audit_table(unique_field, v_run_flag ) %}

 {% if v_run_flag == 'post' %}

    {% set sql -%}
        BEGIN TRANSACTION;
        update dbt_rrajan_dbt_test__audit.UNIQUE_FCT_ORDERS_CUSTOMER_ID set n_records=n_records+5 where unique_field={{unique_field}};
        COMMIT;
    {%- endset %}

    --{% do run_query(sql) %}

    {{ sql }}

   {% endif %}

{% endmacro %}