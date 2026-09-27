-- Product pairs bought in the same order. product_a_id < product_b_id so each pair appears once.
with order_products as (

    select distinct order_id, product_id
    from {{ ref('fct_order_items') }}

),

pairs as (

    select
        a.product_id as product_a_id,
        b.product_id as product_b_id,
        count(*)     as orders_together
    from order_products as a
    inner join order_products as b
        on a.order_id = b.order_id
        and a.product_id < b.product_id
    group by a.product_id, b.product_id

)

select
    pairs.product_a_id,
    pa.product_name                                     as product_a_name,
    pairs.product_b_id,
    pb.product_name                                     as product_b_name,
    pairs.orders_together,
    pairs.orders_together / pa.orders_count             as pct_of_product_a_orders,
    pairs.orders_together / pb.orders_count             as pct_of_product_b_orders
from pairs
inner join {{ ref('dim_products') }} as pa
    on pairs.product_a_id = pa.product_id
inner join {{ ref('dim_products') }} as pb
    on pairs.product_b_id = pb.product_id
