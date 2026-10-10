
-- platform volume
-- total sessions count > session count across all users

select user_id,count(session_id)
from user_sessions
group by user_id
having count(session_id) > (
select avg(totalSession) from 
    (select count(session_id) as totalSession from user_sessions group by user_id)
)
