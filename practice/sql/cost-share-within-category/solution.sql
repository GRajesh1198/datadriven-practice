with cte as (
select category,sum(amount) as total_amount
from cost_allocs
where category in ('compute','storage','network')
group by category
), cte2 as (
  select alloc_id,b.category,cast(b.amount as INT) as whole_dollar_amount,(b.amount*100)/a.total_amount
  from cte a
  join cost_allocs b
  on a.category = b.category
  order by a.category,alloc_id
)
SELECT * FROM CTE2;
