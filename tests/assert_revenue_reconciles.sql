-- Total revenue must agree across every layer that reports it.
with totals as (
    select 'fct_order_items' as source, sum(line_revenue) as revenue from {{ ref('fct_order_items') }}
    union all
    select 'fct_orders', sum(order_revenue) from {{ ref('fct_orders') }}
    union all
    select 'mart_monthly_sales', sum(revenue) from {{ ref('mart_monthly_sales') }}
    union all
    select 'dim_customers', sum(lifetime_revenue) from {{ ref('dim_customers') }}
    union all
    select 'dim_products', sum(revenue) from {{ ref('dim_products') }}
    union all
    select 'mart_sales_by_category', sum(revenue) from {{ ref('mart_sales_by_category') }}
)

select *
from totals
where revenue != (select revenue from totals where source = 'fct_order_items')
