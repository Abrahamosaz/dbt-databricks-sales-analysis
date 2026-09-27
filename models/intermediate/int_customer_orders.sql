-- Orders sequenced per customer.
with sequenced as (

    select
        *,
        row_number() over (partition by customer_id order by ordered_at, order_id) as customer_order_number,
        lag(order_date_local) over (partition by customer_id order by ordered_at, order_id) as previous_order_date_local
    from {{ ref('int_orders') }}

)

select
    *,
    customer_order_number = 1                                  as is_first_order,
    datediff(order_date_local, previous_order_date_local)      as days_since_previous_order
from sequenced
