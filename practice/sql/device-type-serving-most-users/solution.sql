with cte as (SELECT 
  d.device_type,
  count(distinct user_id) as user_count
FROM user_sessions u
join devices d
on d.device_id = u.device_id
group by d.device_type
) 
select * from cte
where cast(user_count as real) > 0.9 * (select max(user_count) from cte)
-- unique users
