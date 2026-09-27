{% snapshot scd_customers %}

{{
    config(
        unique_key='customer_id',
        strategy='check',
        check_cols=['first_name', 'last_name', 'email', 'city', 'country'],
    )
}}

select * from {{ ref('customers') }}

{% endsnapshot %}
