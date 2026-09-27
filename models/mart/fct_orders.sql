select
    o.order_id,
    o.customer_id,
    c.city,
    c.country,
    o.ordered_at,
    o.ordered_at_local,
    o.order_date_local,
    cast(date_trunc('month', o.order_date_local) as date) as order_month,
    o.status,
    o.payment_method,
    o.item_count,
    o.unit_count,
    o.order_revenue,
    o.customer_order_number,
    o.is_first_order,
    o.days_since_previous_order
from {{ ref('int_customer_orders') }} as o
left join {{ ref('stg_customers') }} as c
    on o.customer_id = c.customer_id
