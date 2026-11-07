with cte as (
  select
     user_id,
     endpoint,
     call_time,
     err_msg,
     lag(call_time) over (partition by user_id, endpoint order by call_time) as prev_call_time
  from api_calls
)
 -- find the call that errors within 5 minute of the previous call
 select
    user_id,
    endpoint,
    count(*) as retry_count
 from cte
 where err_msg is not null and (julianday(call_time) - julianday(prev_call_time)) * 24 * 60 <=5
 group by user_id, endpoint
 order by retry_count desc, user_id, endpoint
