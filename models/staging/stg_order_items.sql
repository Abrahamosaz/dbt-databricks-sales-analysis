-- One row per order line item. Order-level attributes are repeated on every line.
select
    order_item_id,
    order_id,
    customer_id,
    product_id,
    order_date                                                          as ordered_at,
    from_utc_timestamp(order_date, '{{ var("reporting_timezone") }}')  as ordered_at_local,
    to_date(from_utc_timestamp(order_date, '{{ var("reporting_timezone") }}')) as order_date_local,
    upper(trim(status))                                                 as status,
    upper(trim(payment_method))                                         as payment_method,
    quantity,
    unit_price,
    cast(quantity * unit_price as decimal(18,2))                        as line_revenue
from {{ ref('orders') }}
