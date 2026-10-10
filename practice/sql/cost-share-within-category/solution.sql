with cte as (
select category,sum(amount) as total_spend
from cost_allocs
where category in ('compute','storage','network')
group by category
)
select alloc_id,b.category,cast(amount as INT) as whole_dollar_amount,((amount/total_spend)*100) as pct_of_category
from cost_allocs a
inner join cte b on a.category = b.category
order by b.category,alloc_id
