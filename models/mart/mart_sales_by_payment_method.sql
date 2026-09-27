select
    payment_method,
    count(distinct customer_id)                         as customers,
    count(*)                                            as orders,
    sum(order_revenue)                                  as revenue,
    sum(order_revenue) / count(*)                       as avg_order_value,
    count(*) / sum(count(*)) over ()                    as order_share,
    sum(order_revenue) / sum(sum(order_revenue)) over () as revenue_share
from {{ ref('fct_orders') }}
group by payment_method
