-- Product attributes are as they were when the order was placed (SCD type 2).
select
    oi.order_item_id,
    oi.order_id,
    oi.customer_id,
    oi.product_id,
    p.product_sk,
    p.category_id,
    oi.ordered_at,
    oi.order_date_local,
    cast(date_trunc('month', oi.order_date_local) as date) as order_month,
    oi.status,
    oi.payment_method,
    oi.quantity,
    oi.unit_price,
    p.list_price,
    oi.line_revenue
from {{ ref('stg_order_items') }} as oi
left join {{ ref('stg_products_history') }} as p
    on  oi.product_id = p.product_id
    and oi.ordered_at >= p.valid_from
    and oi.ordered_at <  p.valid_to
