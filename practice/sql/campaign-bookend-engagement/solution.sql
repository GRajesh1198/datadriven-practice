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

WITH campaign_dates AS (
  SELECT
    ad_campaign,
    MIN(DATE(impression_time)) AS first_day,
    MAX(DATE(impression_time)) AS last_day
  FROM ad_impressions
  GROUP BY ad_campaign
),
campaign_counts AS (
  SELECT
    ad_campaign,
    COUNT(*) AS total_impressions
  FROM ad_impressions
  GROUP BY ad_campaign
)

SELECT
  a.ad_campaign,
  100 * CAST(
    SUM(
      CASE
        WHEN DATE(a.impression_time) = cd.first_day THEN 1
        ELSE 0
      END
    )
    AS REAL
  ) / cc.total_impressions AS first_day_pct,
  100 * CAST(
    SUM(
      CASE
        WHEN DATE(a.impression_time) = cd.last_day THEN 1
        ELSE 0
      END
    )
    AS REAL
  ) / cc.total_impressions AS last_day_pct
FROM ad_impressions AS a
JOIN campaign_dates AS cd
  ON a.ad_campaign = cd.ad_campaign
JOIN campaign_counts AS cc
  ON a.ad_campaign = cc.ad_campaign
GROUP BY a.ad_campaign
ORDER BY a.ad_campaign
