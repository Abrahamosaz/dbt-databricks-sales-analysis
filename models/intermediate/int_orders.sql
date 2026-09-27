-- Collapse line items to one row per order.
-- Grouping by the order-level attributes means any order whose lines disagree
-- on customer/date/status/payment fans out into >1 row and fails the unique test.
select
    order_id,
    customer_id,
    ordered_at,
    ordered_at_local,
    order_date_local,
    status,
    payment_method,
    count(*)            as item_count,
    sum(quantity)       as unit_count,
    sum(line_revenue)   as order_revenue
from {{ ref('stg_order_items') }}
group by
    order_id,
    customer_id,
    ordered_at,
    ordered_at_local,
    order_date_local,
    status,
    payment_method
