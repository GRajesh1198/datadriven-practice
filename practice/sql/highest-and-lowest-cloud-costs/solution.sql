select cost_id,
  amount,
  svc_name,
  case
    when r2= 1 then 'Highest Cost'
    when r1 = 1 then 'Lowest Cost'
   end as cost_type
  from (select
  cost_id,
  amount,
  svc_name,
  dense_rank() over (order by coalesce(amount,0)) as r1,
  dense_rank() over (order by coalesce(amount,0) desc) as r2
  from
    cloud_costs) as c
  where r1 = 1 or r2 = 1 
  order by amount desc
