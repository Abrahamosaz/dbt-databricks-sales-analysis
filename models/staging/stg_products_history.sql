-- One row per version of a product (SCD type 2), from the scd_products snapshot.
-- dbt_valid_from is when the snapshot first saw a version, not when it became true,
-- so each product's first version is opened back to 1900-01-01 so that orders
-- placed before the first snapshot run still match a version.
select
    dbt_scd_id          as product_sk,
    product_id,
    trim(product_name)  as product_name,
    category_id,
    price               as list_price,
    stock_quantity,
    case
        when row_number() over (partition by product_id order by dbt_valid_from) = 1
            then timestamp'1900-01-01 00:00:00'
        else dbt_valid_from
    end                 as valid_from,
    coalesce(dbt_valid_to, timestamp'9999-12-31 00:00:00') as valid_to,
    dbt_valid_to is null as is_current
from {{ ref('scd_products') }}
