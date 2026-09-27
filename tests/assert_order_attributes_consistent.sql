-- Every line of an order must share the same order-level attributes.
select order_id
from {{ ref('stg_order_items') }}
group by order_id
having count(distinct customer_id) > 1
    or count(distinct ordered_at) > 1
    or count(distinct status) > 1
    or count(distinct payment_method) > 1
