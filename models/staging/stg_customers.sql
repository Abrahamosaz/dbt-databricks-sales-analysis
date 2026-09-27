select
    customer_id,
    trim(first_name)                               as first_name,
    trim(last_name)                                as last_name,
    concat_ws(' ', trim(first_name), trim(last_name)) as full_name,
    lower(trim(email))                             as email,
    trim(city)                                     as city,
    trim(country)                                  as country,
    signup_date
from {{ ref('customers') }}
