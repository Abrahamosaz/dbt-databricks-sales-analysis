with sales as (

    select
        product_id,
        count(distinct order_id)    as orders_count,
        sum(quantity)               as units_sold,
        sum(line_revenue)           as revenue
    from {{ ref('stg_order_items') }}
    group by product_id

),

sales_window as (

    -- Observed selling period, used to turn units sold into a daily run rate.
    select datediff(max(order_date_local), min(order_date_local)) + 1 as window_days
    from {{ ref('stg_order_items') }}

)

select
    p.product_id,
    p.product_name,
    p.category_id,
    c.category_name,
    p.list_price,
    p.stock_quantity,
    cast(p.list_price * p.stock_quantity as decimal(18,2))                  as stock_value,
    coalesce(s.orders_count, 0)                                             as orders_count,
    coalesce(s.units_sold, 0)                                               as units_sold,
    coalesce(s.revenue, 0)                                                  as revenue,
    s.product_id is not null                                                as has_sales,
    coalesce(s.units_sold, 0) / nullif(coalesce(s.units_sold, 0) + p.stock_quantity, 0) as sell_through_rate,
    coalesce(s.units_sold, 0) / w.window_days                               as avg_daily_units_sold,
    -- Estimate only: stock has no history, so this assumes the historical run rate continues.
    p.stock_quantity / nullif(s.units_sold / w.window_days, 0)              as estimated_days_of_cover
from {{ ref('stg_products') }} as p
left join {{ ref('stg_categories') }} as c
    on p.category_id = c.category_id
left join sales as s
    on p.product_id = s.product_id
cross join sales_window as w
