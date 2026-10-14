-- with cte as (select
--   ad_campaign,
--   impression_time,
--   impression_id,
--   first_value(impression_time) over (partition by ad_campaign order by impression_time) as fday,
--   first_value(impression_time) over (partition by ad_campaign order by impression_time desc) as lday
--   from
--  ad_impressions)
--  select 
--    ad_campaign,
--    100.00 * (sum(case when strftime('%d-%m-%Y',impression_time) = strftime('%d-%m-%Y',fday) then 1 else 0 end))/count(impression_id) as f,
--    100.00 * (sum(case when strftime('%d-%m-%Y',impression_time) = strftime('%d-%m-%Y',lday) then 1 else 0 end))/count(impression_id) as l
-- from cte
-- group by ad_campaign;

-- I USED STRFTIME() AND FORMATTED THE DATE
-- OPTIMAL USING DATE(COL_WITH_TS)
-- GROUPING CAN BE DONE WITH MAX AND MIN TO GET THE FIRST AND LAST DAY AS WELL 


select
  ad_campaign,
  ROUND(SUM(case when date(impression_time) = (select min(date(impression_time)) from ad_impressions t2 where t1.ad_campaign = t2.ad_campaign) then 1 else 0 end) * 100.0 / count(*), 3) as first_day_pct,
  ROUND(SUM(case when date(impression_time) = (select max(date(impression_time)) from ad_impressions t2 where t1.ad_campaign = t2.ad_campaign) then 1 else 0 end) * 100.0 / count(*), 3) as last_day_pct
from ad_impressions t1
group by ad_campaign;
