select
  alloc_id,
  category,
  cast(amount as INT) as whole_dollar_amount,
  (100*amount)/sum(amount) over (partition by category) as pct_of_category
from cost_allocs
where category in ('compute','storage','network')
