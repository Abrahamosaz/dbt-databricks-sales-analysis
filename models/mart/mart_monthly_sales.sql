with monthly as (

    select
        order_month,
        count(*)                        as orders,
        count(distinct customer_id)     as active_customers,
        count_if(is_first_order)        as new_customers,
        sum(unit_count)                 as units_sold,
        sum(order_revenue)              as revenue
    from {{ ref('fct_orders') }}
    group by order_month

)

select
    order_month,
    orders,
    active_customers,
    new_customers,
    units_sold,
    revenue,
    revenue / orders                                                    as avg_order_value,
    lag(revenue) over (order by order_month)                            as previous_month_revenue,
    (revenue - lag(revenue) over (order by order_month))
        / lag(revenue) over (order by order_month)                      as revenue_mom_pct,
    sum(revenue) over (order by order_month)                            as cumulative_revenue
from monthly
