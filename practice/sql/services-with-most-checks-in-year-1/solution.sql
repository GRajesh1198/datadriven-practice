select  svc_name,check_year,check_count,last_trouble_month from (select *,rank() over (partition by svc_name order by check_count desc) as r
  from (
select 
    svc_name,
    strftime('%Y',checked) as check_year,
    count(check_id) as check_count,
    max(strftime('%Y-%m',checked)) as last_trouble_month 
  from
svc_health 
  where lower(status) <> 'healthy'
  group by svc_name,strftime('%Y',checked)
  ) as c ) as c2
  where r = 1
