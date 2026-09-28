-- One row per version of a customer (SCD type 2), from the scd_customers snapshot.
-- dbt_valid_from is when the snapshot first saw a version, not when it became true,
-- so each customer's first version is opened back to 1900-01-01 so that orders
-- placed before the first snapshot run still match a version.
select
    dbt_scd_id                                        as customer_sk,
    customer_id,
    trim(first_name)                                  as first_name,
    trim(last_name)                                   as last_name,
    concat_ws(' ', trim(first_name), trim(last_name)) as full_name,
    lower(trim(email))                                as email,
    trim(city)                                        as city,
    trim(country)                                     as country,
    signup_date,
    case
        when row_number() over (partition by customer_id order by dbt_valid_from) = 1
            then timestamp'1900-01-01 00:00:00'
        else dbt_valid_from
    end                                               as valid_from,
    coalesce(dbt_valid_to, timestamp'9999-12-31 00:00:00') as valid_to,
    dbt_valid_to is null                              as is_current
from {{ ref('scd_customers') }}
