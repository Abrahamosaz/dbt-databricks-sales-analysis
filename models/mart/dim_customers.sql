with order_stats as (

    select
        customer_id,
        min(order_date_local)          as first_order_date,
        max(order_date_local)          as last_order_date,
        count(*)                       as lifetime_orders,
        sum(order_revenue)             as lifetime_revenue,
        avg(days_since_previous_order) as avg_days_between_orders
    from {{ ref('int_customer_orders') }}
    group by customer_id

),

customers as (

    select
        c.customer_id,
        c.first_name,
        c.last_name,
        c.full_name,
        c.email,
        c.city,
        c.country,
        c.signup_date,
        s.first_order_date,
        s.last_order_date,
        coalesce(s.lifetime_orders, 0)                                  as lifetime_orders,
        coalesce(s.lifetime_revenue, 0)                                 as lifetime_revenue,
        s.lifetime_revenue / s.lifetime_orders                          as avg_order_value,
        datediff(s.first_order_date, c.signup_date)                     as days_signup_to_first_order,
        s.avg_days_between_orders,
        s.customer_id is not null                                       as has_ordered,
        coalesce(s.lifetime_orders, 0) > 1                              as is_repeat_customer
    from {{ ref('stg_customers_history') }} as c
    left join order_stats as s
        on c.customer_id = s.customer_id
    where c.is_current

),

ranked as (

    select
        *,
        case when has_ordered then
            row_number() over (partition by has_ordered order by lifetime_revenue desc, customer_id)
        end                                                              as revenue_rank,
        count_if(has_ordered) over ()                                    as buying_customers,
        lifetime_revenue / sum(lifetime_revenue) over ()                 as revenue_share
    from customers

)

select
    customer_id,
    first_name,
    last_name,
    full_name,
    email,
    city,
    country,
    signup_date,
    first_order_date,
    last_order_date,
    lifetime_orders,
    lifetime_revenue,
    avg_order_value,
    days_signup_to_first_order,
    avg_days_between_orders,
    has_ordered,
    is_repeat_customer,
    revenue_rank,
    revenue_share,
    coalesce(revenue_rank <= ceil(0.2 * buying_customers), false)       as is_top_20_pct
from ranked
