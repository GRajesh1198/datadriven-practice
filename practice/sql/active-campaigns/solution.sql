select 
  ad_campaign,
  count(impression_id) as impressions,
  sum(revenue) as total_revenue,
  round(100.0 * sum(case 
      when clicked then 1 else 0
   end)/count(impression_id),1)as ctr
from ad_impressions
group by ad_campaign
having count(impression_id) > 15
order by 4 desc, 1
