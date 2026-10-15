-- select * from (select
--   --- second session should start before previous one ends
--   user_id,
--   session_id as session_id1,
--   session_start as start_1,
--   dateadd(second,session_duration_sec,session_start) as end_time,
--   lead(session_id) 
--     over(partition by user_id 
--       order by session_start 
--       rows between current row and unbounded following) as session_id2,
--   lead(session_start) 
--     over(partition by user_id 
--       order by session_start 
--       rows between current row and following) as start_2
-- from
-- user_sessions) as cte
-- where start_2 between start_1 and end_time

select
  u1.user_id,
  u1.session_id as session_id_1,
  u2.session_id as session_id_2,
  u1.session_start as start_1,
  u2.session_start as start_2
  from user_sessions u1
  join user_sessions u2
  on u1.user_id = u2.user_id and 
      u1.session_id <> u2.session_id and
    u2.session_start between u1.session_start and dateadd(second,u1.session_duration_sec,u1.session_start)
order by u1.user_id
