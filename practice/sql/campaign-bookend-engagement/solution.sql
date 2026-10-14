with cte as (select
  ad_campaign,
  impression_time,
  impression_id,
  first_value(impression_time) over (partition by ad_campaign order by impression_time) as fday,
  first_value(impression_time) over (partition by ad_campaign order by impression_time desc) as lday
  from
 ad_impressions)
 select 
   ad_campaign,
   100.00 * (sum(case when strftime('%d-%m-%Y',impression_time) = strftime('%d-%m-%Y',fday) then 1 else 0 end))/count(impression_id) as f,
   100.00 * (sum(case when strftime('%d-%m-%Y',impression_time) = strftime('%d-%m-%Y',lday) then 1 else 0 end))/count(impression_id) as l
from cte
group by ad_campaign;
