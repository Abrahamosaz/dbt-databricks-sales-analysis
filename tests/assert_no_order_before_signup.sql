-- A customer cannot place an order before creating their account.
-- Severity is warn: the source currently has orders predating signup_date
-- (likely signup_date reflects account registration after guest checkout).
-- Surface it for the business rather than block the pipeline.
{{ config(severity='warn') }}

select o.order_id, o.customer_id, o.order_date_local, c.signup_date
from {{ ref('fct_orders') }} as o
inner join {{ ref('stg_customers') }} as c
    on o.customer_id = c.customer_id
where o.order_date_local < c.signup_date
