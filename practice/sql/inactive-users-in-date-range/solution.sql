select username from
 users u
left join user_sessions s
on u.user_id = s.user_id and date(session_start) between '2026-06-01' and '2026-07-01'
where session_id is null
