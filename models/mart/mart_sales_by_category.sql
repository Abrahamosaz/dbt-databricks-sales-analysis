select
    category_id,
    category_name,
    count(*)                                            as products,
    count_if(has_sales)                                 as products_sold,
    sum(units_sold)                                     as units_sold,
    sum(revenue)                                        as revenue,
    sum(revenue) / sum(sum(revenue)) over ()            as revenue_share,
    sum(stock_quantity)                                 as stock_quantity,
    sum(stock_value)                                    as stock_value
from {{ ref('dim_products') }}
group by category_id, category_name
