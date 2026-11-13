with cte as (select *,
  lag(call_time) over (partition by user_id order by call_time) as prev_call
from api_calls), cte2 as (
    select *,extract(epoch from call_time - prev_call)/60 as time_diff
    from cte
    where err_msg is not null
 )
 select user_id, endpoint, count(*) as retry_count
  from cte2
  where time_diff <=5
  group by user_id, endpoint
  order by count(*)  desc, user_id, endpoint


-- 1 10:00  error
-- 1 10:02  10:00 error
