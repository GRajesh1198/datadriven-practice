select
  d.device_type,
  cast(avg(session_duration_sec)/60 as REAL) as avg_session_minutes
from user_sessions u
join devices d on u.device_id = d.device_id
group by d.device_type
order by d.device_type
