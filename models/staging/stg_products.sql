select
    product_id,
    trim(product_name)  as product_name,
    category_id,
    price               as list_price,
    stock_quantity
from {{ ref('products') }}