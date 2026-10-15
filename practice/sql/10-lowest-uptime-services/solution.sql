select svc_name,min_uptime from (select 
    svc_name,
    uptime as min_uptime,
    rank() over (order by uptime) as r1
from (select
    svc_name,
    uptime,
    --- lowest within service
    row_number() over (partition by svc_name order by uptime) as r
  from 
    svc_health where uptime is not null) as cte
  where r = 1) as cte2
  where r1 <= 10
