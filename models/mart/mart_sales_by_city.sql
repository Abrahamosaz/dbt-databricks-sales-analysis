select
    city,
    count(distinct customer_id)                         as customers,
    count(*)                                            as orders,
    sum(unit_count)                                     as units_sold,
    sum(order_revenue)                                  as revenue,
    sum(order_revenue) / count(*)                       as avg_order_value,
    sum(order_revenue) / sum(sum(order_revenue)) over () as revenue_share
from {{ ref('fct_orders') }}
group by city
