select team_name,period_cost as monthly_cost from 
(select 
  team_name,
  period_cost,
  row_number() over (partition by team_name order by period_cost desc) as r
  from (
    select
      lower(team_name) as team_name,
      period,
      sum(amount) as period_cost
    from
    cost_allocs
    group by lower(team_name),period
    ) as cte ) as cte2
    where r<=3
