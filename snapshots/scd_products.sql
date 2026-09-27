{% snapshot scd_products %}

{{
    config(
        unique_key='product_id',
        strategy='check',
        check_cols=['product_name', 'category_id', 'price', 'stock_quantity'],
    )
}}

select * from {{ ref('products') }}

{% endsnapshot %}
