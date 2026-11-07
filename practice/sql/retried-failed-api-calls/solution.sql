with cte as (select
  user_id, lower(trim(endpoint)) as endpoint, call_time,
  lead(call_time) over (partition by user_id, endpoint order by call_id) as next_call_time
from api_calls
where 
    err_msg is not null and 
    user_id is not null), cte2 as (
    select user_id,endpoint, datediff(minute,call_time,next_call_time) as minutes
from cte)
select 
  user_id,
  endpoint,
  sum(
  case when minutes < 5 then 1 else 0 end
) as retry_count
from cte2
group by user_id, endpoint
having retry_count > 0
order by retry_count desc, user_id, endpoint
